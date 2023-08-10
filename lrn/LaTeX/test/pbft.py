import threading
from typing import Union, Optional
from threading import Thread, Timer, Lock
import random
import json
# from random import randrange
from time import sleep

lock_for_print = Lock()
def print_mt(*args,**kwargs):
    with lock_for_print:
        print(*args,**kwargs)

class S:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    MAG = '\033[93m'
    RED = '\033[91m'
    NOR = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

from typing import Optional
from collections.abc import Callable

"""🐢 :pbft needs something more than a normal static consensus in that, it
needs digital signature. In particular, sometimes, it needs to store a
particular msg sent by other nodes. For example, N1 needs to show N2 that
'Look, N3 said <...>'. In this case, N1 needs to store the msg containing:

<pk of N3><signature of N3 for `data`><`data`>

In particular, this is needed during view-change, when nodes are asking each
other `hey, what's your state.`

🦜 : Ok, so what do we need ?

🐢 : A signer.
"""

class ISignable:
    def sign(self, msg: str) -> str:
        pass

    def verify(self, msg: str) -> bool:
        pass

    # 🐢 :extract part of the msg, the msg should have been verified already,
    # otherwise the result is undefined.
    def get_data(self, msg: str) -> str:
        pass
    def get_from(self, msg: str) -> str:
        pass
    # def get_sig(self, msg: str) -> str:
    #     pass


class IExecutable:
    def execute(self,command: str):
        pass

"""
🦜 : It looks like pbft needs to know the pks, so in this case, my_id should be `my_pk`?

🐢 : Then it will again be end-point based right?

🦜 : Yeah, and all_ids() should be kept by the cnsss. Emmm.

"""
class IEndpointBasedNetworkable:
    def listen(self,
               target: str,     # The target, e.g. "/"
               handler: Callable[[str,str],Optional[str]]
               # The handler, accepts
               #  - endpoint, e.g. "localhost:8080"
               #  - request data
               # returns the result
               ):
        pass
    def listened_endpoint(self) -> str:
        pass
    def send(self,endpoint: str, target: str, data: str) -> Optional[str]:
        # endpoint: the target, e.g. "localhost:8080"
        # target: e.g. "/hi"
        pass
    def clear(self):                # clears up all the listeners
        pass

class PbftConsensus:
    """The PBFT Consensus. Can also be named <other>PFT depending on how
    IExecutable is implemented."""

    def __init__(self,
                 n : IEndpointBasedNetworkable,
                 e : IExecutable,
                 s : ISignable,
                 all_endpoints : list[str]):
        self.net = n
        self.exe = e
        self.sig = s

        self.all_endpoints = all_endpoints
        self.epoch: int = 0
        self.view_change_state = False
        self.lock_for_patience = Lock()
        self.laid_down_history: dict[int,dict[str,list[str]]] = {}
        self.sig_of_nodes_to_be_added: set[str] = set({})

        # map[epoch -> map[state -> l1 = list of msg that confirm to state (unique)]]

        # 🦜 : the list l1 which contains N* = self.all_endpoints[epoch] forms
        # the new-view-certificate for N*.

        """🦜 : In fact its just the set of following struct:

            {
                'msg' : f'Dear {sub}, I laid downed',
                'epoch' : len(self.epoch),
                'state' : self.get_state(),
                'from' : self.net.listened_endpoint()
            }

        sorted first by epoch:int, then by state:string

        🐢 : But I feel like this tree-like structure is easier to manage and
        access. No ?

        🦜 : True

        """


        # 🦜 : This list of commands to be confirmed. This is kinda like a
        # counter. When a command has reached more than 2f + 1 count (confirmed
        # message) then the command can be savely executed.
        #
        # The meaning of to_be_confirmed_commands is kinda like : <cmd> : {set of who received commands}
        #
        # So when two sub-nodes call each other, they will exchange what
        # they've got in their hand. As a result, eventually the node will
        # still execute what primary sent to most nodes. (🦜: This eventually makes each nodes "selfless").
        self.to_be_confirmed_commands: dict[str,set[str]] = {}  # recieved from primary

        # The commands received by primary, subs will forward many copied of
        # command to primary, and the primary just need to accept once.
        self.recieved_commands: set[str] = set({})  # recieved by primary
        self.command_history: list[str] = []  # executed

        if self.net.listened_endpoint() not in self.all_endpoints:
            self.start_listening_as_newcomer()


        if self.primary() == self.net.listened_endpoint():
            self.start_listening_as_primary()
        else:
            self.start_listening_as_sub()

        Thread(target=self.start_faulty_timer).start()  # here the ctor ends



    def clear_and_listen_common_things(self):
        self.view_change_state = False
        self.net.clear()
        self.net.listen('/pleaseGiveMeUrCmds',self.handle_give_cmds)
        self.net.listen('/ILaidDown',self.handle_handle_laid_down)
        self.net.listen('/IamThePrimary',self.handle_new_primary)

        self.net.listen('/pleaseAddMe',self.handle_add_new_nodes)
        self.net.listen('/addNewNodesNoBoardcast',self.handle_add_new_nodes_no_boardcast)

    def handle_new_primary(self, endpoint: str, data: str) -> str:
        """endpoint said it's the primary, if the data contains the required
        things, then we follow it"""

        try:
            o = json.loads(data)
        except json.JSONDecodeError:
            self.say(f'Error parsing new-view-cert {o}')
            return False

        # 🦜 : Should be parsed to something like:

        if self.epoch >= o['epoch']:
            self.say(f'Ignoring older msg in epoch={o["epoch"]}')
            return False

        # {
        #     'msg' : f'Hi {sub}, I am the primary now.',
        #     'epoch' : e,
        #     'new-view-certificate' : my_list}
        if self.check_cert(o['view-change-certificate'],o['epoch']):
            self.epoch = o['epoch']
            self.say(f'🐸 view changed to {self.epoch}')
            self.comfort()             # #reset the timer
            self.start_listening_as_sub()
            return 'ok'

        self.say(f'Invalid certificate: {S.RED + o + S.NOR} from {S.CYAN + endpoint + S.NOR}, Do nothing')
        return 'no'

    def check_cert(self,l: list[str], e: int) -> bool:
        """Check wether the view-change certificate is valid.

        🦜 : The view-change certificate is valid if

           1. All msgs in it are properly signed.

           2. The state-hash and epoch of them are all the same. In particular,
           the epoch of them should all be equal to `e`. And the state(-hash)
           should all be equal to our hash

           3. And they must have been sent from different nodes.

           4. And that's it...?


        🐢 : Yeah, and it is also possible that we are different from the
           world, in that case... We stop

        """

        valid_host : set[str] = set({})
        try:
            for s in l:
                assert self.sig.verify(s)

                cert = json.loads( self.sig.data(s))
                valid_host.add(self.sig.get_from(s))

                assert cert['state'] == self.get_state()
                assert cert['epoch'] == e

            if len(valid_host) < self.get_f() + 1:
                self.say(f'Requires {self.get_f() + 1} nodes, but got {len(valid_host)}')
                return False

        except json.JSONDecodeError as err:
            self.say(f'Error loading Json for view-change-msg: {err}')
            return False

        except AssertionError as a:
            self.say(f'AssertionError: {a}')
            return False

        self.say(f'Received ok view-change-msg from:\n{S.CYAN} {valid_host} {S.NOR}')
        return True

    def start_listening_as_primary(self):
        self.clear_and_listen_common_things()
        self.net.listen('/whatsYourState',
                        self.handle_get_state)
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_primary)
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_primary)

    def start_listening_as_sub(self):
        self.clear_and_listen_common_things()
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_sub)

    def primary(self) -> str:
        "The current primary"
        return self.all_endpoints[self.epoch % len(self.all_endpoints)]

    def handle_get_state(self, endpoint: str, data: str) -> str:
        """Get the state of the current node, when asked by others. This is
        (almost always) during view-change.

        🦜 : This should be signed right?

        🐢 : Yeah
        """
        return self.get_signed_state()

    @staticmethod
    def cmds_to_state(cmds: list[str]) -> str:
        """Make a `state string` according to `self.command_history`, Get the
        (hash of) state, which should only be changed by the cmd executed so
        far.

        🦜 : Technically we should hash the commands history so far, but for
        now...

        🐢 : Let's just use:
        """
        return ':'.join(cmds)

    def get_state(self) -> str:
        return PbftConsensus.cmds_to_state(self.command_history)

    def get_signed_state(self) -> str:
        """Get the signed state"""
        return self.sig.sign(self.get_state())

    def handle_execute_for_sub(self,endpoint: str,data: str) -> str:
        """🐢 : All things starts with handle_execute_for_sub/primary(), which
        is like the gateway of the node. So if we disable this, then"""
        if self.view_change_state:
            return f"""
            Dear {endpoint}
                  We are currently selecting new primary for epoch {len(self.epoch) + 1}.
                  Please try again later.
            """

        if endpoint == self.primary():
            self.add_to_to_be_confirmed_commands(self.net.listened_endpoint(),data)
            return 'OK'

        # forward
        r = self.net.send(self.primary,'/pleaseExecuteThis',data)
        if r == None:
            self.say('⚠️ What ? primary is down? I will change.')
            self.trigger_view_change()
        return r

    def add_to_to_be_confirmed_commands(self, endpoint:str, data:str) ->int:
        """Remember that endpoint `received` data. If """
        if data not in self.to_be_confirmed_commands:
            self.say(f'Adding {S.MAG + data + S.NOR} from {S.MAG + endpoint + S.NOR}')
            self.to_be_confirmed_commands[data] = {endpoint}

        else:
            s: set[str] = self.to_be_confirmed_commands[data]
            s.add(endpoint)
            if (len(s)) > self.num_of_correct_nodes():
                self.say(f'⚙️ command {S.MAG + data + S.NOR} comfirmed by {len(s)} nodes, executing it.')


    def get_f(self) -> int:
        """Get the number of random nodes the system can tolerate"""
        N = len(self.all_endpoints)
        f = (N - 1) // 3        # number of random nodes
        return f

    def num_of_correct_nodes(self) -> int:
        """Return the value of 2f + 1, where N should be 3f + 1. The greater
        the value, the more correct nodes the cluster needs."""
        N = len(self.all_endpoints)
        f = (N - 1) // 3        # number of random nodes
        return N - f            # number of correct nodes

    def start_faulty_timer(self):
        """Life always has up-and-downs, but time moves toward Qian.

        🦜: The faulty timer is just a clock that keeps calling
        trigger_view_change(). It will not be reset by anybody except a
        new-primary with a new-view-certificate.

        """
        self.comfort()

        p = -1
        with self.lock_for_patience:
            p = self.patience

        while p > 0:
            sleep(2)
            with self.lock_for_patience:
                self.patience -= 1
                p = self.patience
            self.say(f' patience >> {p}, 🐢PR: {S.BLUE} {self.primary()} {S.NOR}')

    def comfort(self):          # reset timer
        with self.lock_for_patience:
            self.patience = 10
            self.say(f'❄ patience set to = {self.patience}')

    # 🦜 : Different N for different f is:
    # f = 0 ⇒ N = 3f + 1 = 1
    # f = 1 ⇒ N = 3f + 1 = 4 (four nodes can tolerate 1)
    # f = 2 ⇒ N = 3f + 1 = 7 (7 nodes can tolerate 2)

    def laid_down_early(self):
        """When a node failed to forward msg to primary, it lies down early for
        this view"""
        self.view_change_state = True

    def trigger_view_change(self):
        """When a node triggers the view-change, it borad cast something like
        'I laid down with this state: {...} for view {0}'

        And others will listens to it.
        """
        self.epoch += 1
        self.say('ViewChange triggered')
        self.view_change_state = True

        next_primary = self.all_endpoints[self.epoch % len(self.all_endpoints)]

        # Send to next_primary the state of me
        self.net.send(next_primary,'/ILaidDown',
                      self.sig.sign(
                          json.dumps(
                              {
                                  'msg' : f'Dear {next_primary}, I laid down for U',
                                  'epoch' : self.epoch,
                                  'state' : self.get_state(),
                                  'from' : self.net.listened_endpoint()
                              }
                          )
                      ))

    def handle_laid_down(self, endpoint: str, data: str) -> str:
        """Response to a `laid-down` msg.

        🐢 : The goal is to see wether the `next primary` is OK. We need to
        receive 2f msgs (plus this node itself, then it should have 2f + 1 state) to check
        that.

        In particular, the state of `next primary` must be known.

        🦜 : What if we already got 2f msgs, but didn't got the one from `next primary`?

        🐢 : Let's ask it explicitly?

        🦜 : Yeah, and if it doesn't reply. We do a new view-change.
        """

        try:
            if not self.sig.verify(data):
                self.say(f'❌️ Pk-verification failed, ignoring msg: {data}')
                return "No"

            o: dict[str, Union[str,int]] = json.loads(self.sig.get_data(data))
            if o['epoch'] < self.epoch:
                self.say(f'🚮️ Ignoring lower epoch laid-down msg: {o}')
                return 'No'

            # 🦜 : In fact, I only cares about it if it's about me.
            next_primary = self.all_endpoints[o['epoch'] % len(self.all_endpoints)]
            if next_primary != self.net.listened_endpoint():
                self.say(f'🚮️ This view-change is non of my bussinesses: {o}')
                return 'No'

            state: str = o['state']
            to_be_added_list : list[str] = self.laid_down_history.get(o['epoch'],
                                                                      dict({})).get(o['state'],
                                                                                    dict({}))
            # 🦜 : This is the list that data (signed msg) will be added in.
            if data in to_be_added_list:
                self.say(f'🚮️ Ignoring duplicated msg from {o["from"]}')
                return 'No'

            to_be_added_list.append(data)

            if len(to_be_added_list) > 2 * self.get_f():
                self.try_to_be_primary(o['epoch'],state,to_be_added_list)

            # 🦜 : It is my bussinesses and the epoch is right for me. I am just
            # ganna get majority of same-state, and if I am not one of them...
            #
            # I will sync to one of them.
            #
            #🐢 : What if the node "doesn't let you synk to its state?"
            #
            #🦜 : Then I will keep trying all these 2f + 1 nodes
        except json.JSONDecodeError as e:
            self.say(f'Error parsing msg: {data}')
            return 'No'

    def get_newcommers(self, sigs: list[str]) -> list[str]:
        """Verify and get the newcommers collected"""
        o : list[str] = []
        for sig in sigs:
            if not self.sig.verify(sig):
                continue
            n = self.sig.get_from(sig)
            if n not in o:
                self.say(f'Adding node {n}')
                o.append(n)

        self.say(f'Got newcomers {o}')
        return o

    def try_to_be_primary(self,e: int,state: str, my_list: list[str]):
        self.say(f'This\'s my time for epoch :{e}, my state is: \n'+
                 '{ S.CYAN + self.get_state() + S.NOR} \n'+
                 'And the majority has state: \n' +
                 '{ S.CYAN + state + S.NOR} \n'
                 )

        # It's my view
        assert self.all_endpoints[e % len(self.all_endpoints)] != self.net.listened_endpoint

        if self.get_state() != state:
            raise Exception('I am different from other correct nodes. The '+
                            'cluster might contained too many random nodes.')

        """

        🐢 : Add those new nodes, and notify them that they are in. The things
        that needs to be sent to the newcomers are different from those sent to
        other subs. In particular, it needs to send 'cmds' to those newcomers
        too, in addition to what's sent to everybody.

        """

        failed_count: int = 0

        m = {'msg' : f'Hi I am the primary now.',
             'epoch' : e,
             'new-view-certificate' : my_list,
             'sig_of_nodes_to_be_added' : list(self.sig_of_nodes_to_be_added)
             }


        # board-cast the list,ignoring the result to existing subs
        for sub in self.all_endpoints:
            if sub != self.net.listened_endpoint():
                r = self.net.send(sub,'IamThePrimary',json.dumps(m))
                if r != 'ok':
                    failed_count += 1

        self.say(f'boardcast finished, got {S.MAG + failed_count + S.NOR} failed')

        if failed_count > self.get_f():
            raise Exception('Too many nodes refuse to let me be the primary. (Probably too many random nodes)')

        """
        🐢 : Notify the newcomers
        """
        # get and add in the newcomers
        newcomers : list[str] = self.get_newcommers(list(self.sig_of_nodes_to_be_added))
        self.sig_of_nodes_to_be_added.clear()
        self.all_endpoints += newcomers

        m['cmds'] = self.command_history

        # Send them the msg, in particular: the cmds.
        for  newcomer in newcomers:
            self.net.send(newcomer,'IamThePrimaryForNewcomer',json.dumps(m))

        # 🦜 : In fact, the above can all be called asynchronously.

        # be the primary
        self.epoch = e          # which should point to me.
        self.start_listening_as_primary()



    def handle_give_cmds(self, endpoint: str, data: str) -> str:
        return json.dumps({
            'cmds' : self.command_history
        })



    def handle_execute_for_primary(self, endpoint: str, data: str) -> str:
        if self.view_change_state:
            return f"""
            Dear {endpoint}
                  We are currently selecting new primary for epoch {len(self.epoch) + 1}.
                  Please try again later.
            """

        if data in self.recieved_commands:
            return f"I received this."

        cmd = data
        self.recieved_commands.add(data)
        self.command_history.append(cmd)
        self.exe.execute(cmd)
        # 🦜 : Can primary just execute it?
        # 
        # 🐢 : Yeah, it can. Then it just assume that the group has 2f + 1
        # correct nodes, and that should be fine. It doesn't bother checking

        for sub in self.all_endpoints[1:]:
            self.net.send(sub,'/pleaseExecuteThis',cmd)

        return f"""
        Dear {endpoint}

             Your request has been carried out by our *BFT group. And if
             everything goes well, your cmd will be executed by all the Correct
             Nodes of out cluster

             Members: {self.all_endpoints}
                 Sincerely
                 {self.net.listened_endpoint()}, The primary.
        """

    def is_primary(self) ->bool:
        """Check whether I am primary"""
        if self.view_change_state:
            return False # during view-change, no primary

        return self.primary() == self.net.listened_endpoint()

    def my_id(self) -> int:
        """Throw if not found"""
        return self.all_endpoints.index(self.net.listened_endpoint())

    def say(self,s: str):
        """Say something """
        print_mt(f'{S.CYAN}\t[{self.my_id()}]{S.NOR}: '
                  + s)

    def handle_add_new_nodes(self, endpoint: str, data: str) -> str:
        """Add a new node, this just remembers the add-new msg, which should
        have been signed by putting it into the self.sig_of_nodes_to_be_added.
        """

        self.sig_of_nodes_to_be_added.add(data)
        for node in self.all_endpoints:
            if node != self.net.listened_endpoint():
                self.net.send(node,'/addNewNodesNoBoardcast',data)

        #    ^^ a set
        """ 🐢 : Using a set is ok, in fact only the next-primary needs to
        remember it, and it will boardcast it when becoming the new primary. At
        that time, it turns the set into a list.

        🦜 : Do we need to check the result ?

        🐢 : Technically, we do. And the majority should answer 'OK'

        """

        return 'OK'

    def handle_add_new_nodes_no_boardcast(self, endpoint: str, data: str) -> str:
        self.sig_of_nodes_to_be_added.add(data)
        return 'OK'

    def start_listening_as_newcomer(self):
        self.net.send(self.all_endpoints[0], '/pleaseAddMe',self.sig.sign('Hi,please let me in.'))
        self.net.listen('/IamThePrimaryForNewcomer',handler=self.handle_new_primary_for_newcomer)

    def handle_new_primary_for_newcomer(self, endpoint: str, data: str) -> str:
        """The data for handle_new_primary_for_newcomer should be same as the
        one received by handle_new_primary(), but with the additional field :
        'cmds', which contains the cmds that the new node should execute.

        So it should be parsed into something like

        d = {
            'epoch' : 2,
            'sig_of_nodes_to_be_added' : ['sig1','sig2'],
            'cmds' : ['c1','c2'],
            'new_view_certificate' : ['sig1','sig2'],
            'msg' : 'Hi, I am the primary now'
        }
        """

        try:
            d = json.loads(data)
        except json.JSONDecodeError:
            self.say(f'Failed to parse data:\n{ S.CYAN + data + S.NOR}, ignoring it')
            return 'No'


        # Check wether the view-change is valid:
        if not self.check_cert(d['view-change-certificate'],d['epoch']):
            self.say(f'Invalid certificate: {S.RED + o + S.NOR} from {S.CYAN + endpoint + S.NOR}, Do nothing')
            return 'no'


        # 🦜 : We assume that required fields are in d

        self.add_newcomers(d['sig_of_nodes_to_be_added'])
        if self.net.listened_endpoint not in self.all_endpoints:
            raise Exception('What ? I am not added by the new view?')


        for cmd in d['cmds']:
            self.exe.execute(cmd)

        self.start_listening_as_sub()

        self.epoch = o['epoch']
        self.say(f'🐸 view changed to {self.epoch}')
        self.start_listening_as_sub()

        Thread(target=self.start_faulty_timer).start()  # here where the new node are added

        return 'ok'


    def add_newcomers(self, sigs: list[str]):
        """Add the signers in all_endpoints """
        self.all_endpoints += self.get_newcommers(sigs)
        self.say(f'all_endpoints updated to {self.all_endpoints}')





#--------------------------------------------------
"""
🦜 :Below we try to use the PBFT
"""

class MockedExecutable(IExecutable):
    def __init__(self, i: str):
        self.id = i
    def execute(self,command: str):
        print_mt(f'🦜 {S.RED} [{self.id}] Exec: {command} {S.NOR}')


network_hub : dict[str, Callable[[int,str],Optional[str]]] = dict()
lock_for_netwok_hub = Lock()
class MockedEndpointNetworkNode(IEndpointBasedNetworkable):
    def __init__(self,e: str):
        self.endpoint = e
    def listened_endpoint(self) -> str:
        return self.endpoint
    def listen(self,
               target: str,
               handler: Callable[[int,str],Optional[str]]
               ):
        k = f'{self.endpoint}-{target}'
        print_mt(f'Adding handler: {k}')
        network_hub[k] = handler

    def clear(self):                # clears up all the listeners
        """🦜 : In fact there's no role-change in ListenToOneConsensus,
        therefore no ones is gonna call this."""
        with lock_for_netwok_hub:
            for k in list(network_hub.keys()):
                if k.startswith(f'{self.endpoint}-'):
                    print_mt(f'Removing handler: {k}')
                    network_hub.pop(k)

    def send(self,e: str, target: str, data: str) -> Optional[str]:
        k = f'{e}-{target}'
        print_mt(f'{S.CYAN} Calling handler: {k} {S.NOR} with data:\n {S.CYAN} {data} {S.NOR}')
        if k in network_hub:
            r = network_hub[k](self.endpoint,data)
        else:
            print_mt(f'Handler {k} not found')
            r = None
        print_mt(f'Got result:{S.GREEN} {r} {S.NOR}')
        return r

"""
🐢 : The above two classes are copied from ListenToOneConsensus. But in
           addition to that, we need a signer which will do digital signtature.
"""

class MockedSigner(ISignable):
    """A mocked signer. This one won't work if `id` or `msg` to be signed
           contains the char `:`"""
    def __init__(self,i:str):
        self.id = i

    def sign(self, msg: str) -> str:
        return self.id + ':' + msg

    def verify(self, msg: str) -> bool:
        return True

    # 🐢 :extract part of the msg, the msg should have been verified already,
    # otherwise the result is undefined.
    def get_data(self, msg: str) -> str:
        l = msg.split(':')
        print_mt(f'⚙️ Extract data in {S.CYAN}{l}{S.NOR}')
        return l[1]

    def get_from(self, msg: str) -> str:
        l = msg.split(':')
        print_mt(f'⚙️ Extract from in {S.CYAN}{l}{S.NOR}')
        return l[0]


"""🐢 : Different to ListenToOneConsensus, nodes in *bft must be started simultaneously.

🦜 : Why ?

🐢 : Because their faulty timmer needs to be synced (they must be started at a
           certain time).

🦜 : So how do we add new nodes?

🐢 : I think we've got two methods:

    1. Define a special type of command, called 'pleaseAddMe:<from>'. And when
           the nodes are about to execute it, instead of calling the underlying
           exe, it will parse that command and add that to the
           `self.all_endpoints`.

    2. Add a new listening target: '/pleaseAddMe' for all nodes. And whenever a
           new node wants to join the group. It will just call a node, and that
           node should borad-casting that '/pleaseAddMe' to uptate the
           'self.all_endpoints'.

🦜 : But then, can random nodes can just keep sending '/pleaseAddMe' to add the
    arbitrary new nodes?

🐢 : No. The msg send in '/pleaseAddMe' should be signed by the newly added
    node, and the 'from' of that msg will be added to 'self.all_endpoints',
    which cannot be forged.

🦜 : Make sense. What about the new node? What does it need to do? After
    sending '/pleaseAddMe', it can't just start its faulty timmer right?

🐢 : Yeah, I think a sensible way is just that, it stays still and waits for
    the next 'IamThePrimary' , which should starts its timmer.

🦜 : But what if the 'next primary' turns out to be that new node?...

🐢 : ......Ok....

🐢 : How about when '/pleaseAddMe' is called, the existing nodes will add that
    new node to a 'self.sig_of_nodes_to_be_added'. And when a new '/IamThePrimary' is
    triggered, the new node in 'self.sig_of_nodes_to_be_added' will be popped into
    'self.all_endpoints'.

🦜 : That makes sense. It's also dangerous here because the that new nodes
    should be awakened by '/IamThePrimary' too.

🐢 : I thinks that's the primary's job. Also I think the primary should awaken
    the newly added nodes with some special commands such as
    `/IamThePrimaryForNewcomer`, in this command, the `executed_commands`
    should also be passed.

🦜 : So how do we implement it?

🐢 : First, the node needs to know whether it is a newcomer. I thinks a simple
    way to do that is just to check whether .listened_endpoint() is in
    all_endpoints().

🦜 : Smart. What's next?

🐢 : Next, the newcomer will 'start_listening_as_newcomer()'. In details,

        1. It sends a '/pleaseAddMe' to f+1 existing nodes, this will make sure
        that at least one correct node receives this. (🦜 : An alternative way
        could be that it just sends to one node and pray for the fact that the
        node it contact to is correct. 🐢 : That's ..Ok for now)

        2. It listens for '/IamThePrimaryForNewcomer' which should contains
        the commands so far, and start_listening_as_sub().

🦜 : I think inside the msg of '/IamThePrimaryForNewcomer' and
        '/IamThePrimary', the new primary can also boardcast its
        'self.listened_endpoints'.

🐢 : Indeed. That's the easier way to allow us to add more than one nodes per
        epoch.

🦜 : Fine, I changed my mind. Let's just allow one node to be added per epoch.
        Wait....No, let's relex it, boardcast the 'self.listened_endpoints'.

🐢 : Okay

🦜 : Wait, there's another way. We can just store the msg in
        `self.sig_of_nodes_to_be_added` and then in '\IamThePrimary', we just pass the
        `self.sig_of_nodes_to_be_added`, which should also contain the signature of new
        node.

🐢 : Smart. Take advantage of digital signature.

"""

# from wonderwords import RandomWord
# class NodeFactory:
#     nodes: dict[str,ListenToOneConsensus] = dict()
#     r = RandomWord()
#     primary_name = ''
#     def make_node(self):
#         i = len(self.nodes)
#         # s = self.r.word(word_max_length=4)

#         s = f'N{i}'
#         e = MockedExecutable(s)
#         n = MockedEndpointNetworkNode(s)

#         if i == 0:
#             self.nodes[s] = ListenToOneConsensus(n=n,e=e)
#             self.primary_name = s
#             return
#         self.nodes[s] = ListenToOneConsensus(n=n,e=e,nodeToConnect=self.primary_name)

# fac = NodeFactory()
# for i in range(3): fac.make_node()

# nClient = MockedEndpointNetworkNode('ClientAAA')
# while True:
#     # reply = input('Enter cmd: <id> <cmd>')
#     reply = input('Enter: ')
#     if reply == 'stop': break
#     if reply == 'append':
#         print_mt(f'{S.HEADER} Appending node {S.NOR}')
#         fac.make_node()
#         continue
#     l = reply.split(' ')
#     if l[0] == 'kick':
#         print_mt(f'{S.HEADER} Kicking node {l[1]} {S.NOR}')
#         fac.nodes[l[1]].net.clear()
#         continue

#     print_mt(f'{S.HEADER} Sending {l[1]} to {l[0]} {S.NOR}')
#     nClient.send(l[0],'/pleaseExecuteThis',l[1])
