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

def plural_maybe(n : int, s: str = 's', s0: str = ''):
    """The plural suffix"""
    return s if n > 1 else s0

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

class IAsyncEndpointBasedNetworkable:
    """🦜 : *bft needs a type of asynchronous call. It's kinda like an
    'irresponsible call' which just send the request and doesn't care whether
    it's delivered.

    This changes two things:

       1. handler should be void(str,str). (🦜 : Okay, for now I am gonna stay
       Optional[str] for debugging purpose.)

       2. send should not return (and start a new thread)

    """
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
    def send(self,endpoint: str, target: str, data: str):
        # endpoint: the target, e.g. "localhost:8080"
        # target: e.g. "/hi"
        pass
    def clear(self):                # clears up all the listeners
        pass


class PbftConsensus:
    """The PBFT Consensus. Can also be named <other>PFT depending on how
    IExecutable is implemented."""

    def __init__(self,
                 n : IAsyncEndpointBasedNetworkable,
                 e : IExecutable,
                 s : ISignable,
                 all_endpoints : list[str]):

        self.closed = False     # flag checked by timer

        self.net = n
        self.exe = e
        self.sig = s

        self.all_endpoints = all_endpoints
        self.epoch: int = 0
        self.view_change_state = False

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

        self.lock_for = {
            'to_be_confirmed_commands' : Lock(),
            'sig_of_nodes_to_be_added' : Lock(),
            'laid_down_history' : Lock(),
            'patience' : Lock(),
            'all_endpoints' : Lock(),
            'recieved_commands' : Lock(),
            'command_history' : Lock(),
        }

        # The commands received by primary, subs will forward many copied of
        # command to primary, and the primary just need to accept once.
        self.recieved_commands: set[str] = set({})  # recieved by primary
        self.command_history: list[str] = []  # executed

        if self.net.listened_endpoint() not in self.all_endpoints:
            self.start_listening_as_newcomer()
            # 🦜 : Will only start the timer once added.
        else:
            if self.primary() == self.net.listened_endpoint():
                self.start_listening_as_primary()
            else:
                self.start_listening_as_sub()

            Thread(target=self.start_faulty_timer).start()  # here the ctor ends



    def clear_and_listen_common_things(self):
        self.view_change_state = False
        self.net.clear()
        self.net.listen('/ILaidDown',self.handle_laid_down)
        self.net.listen('/IamThePrimary',self.handle_new_primary)

        self.net.listen('/pleaseAddMe',self.handle_add_new_node)
        self.net.listen('/pleaseAddMeNoBoardcast',self.handle_add_new_node_no_boardcast)

    def handle_new_primary(self, endpoint: str, data: str) -> str:
        """endpoint said it's the primary, if the data contains the required
        things, then we follow it.

        Here we should also handle adding-new nodes.
        """

        try:
            o = json.loads(data)
        except json.JSONDecodeError:
            self.say(f'Error parsing new-view-cert {o}')
            return 'No'

        # 🦜 : Should be parsed to something like:
        # {
        #     'msg' : f'Hi {sub}, I am the primary now.',
        #     'epoch' : e,
        #     'new-view-certificate' : my_list}

        """
        🦜 : Every time new nodes are added in the cluster, the epoch will be
        recalculated .
        """
        newcomers = self.get_newcommers(o['sig_of_nodes_to_be_added'])
        with self.lock_for['all_endpoints']:
            for newcomer in newcomers:
                if newcomer in self.all_endpoints:
                    self.say('This primary has old newcomer, ignoring it.')
                    return 'No'

        if self.epoch >= o['epoch']:
            self.say(f'Ignoring older msg in epoch={o["epoch"]}')
            return 'No'

        if self.check_cert(o['view-change-certificate'],o['epoch']):
            """

            🦜 : Now we are ready to start a new view. We do the following:

            1. update the epoch
            2. reset the timer
            3. clear the laid_down_history
            4. clear the sig_of_nodes_to_be_added
            5. add the newcomers as per primary.
            6. start as sub

            """
            # 1.
            e = o['epoch']
            self.epoch = self.epoch_considering_newcomers(e, len(newcomers))
            self.say(f'🐸 view changed to {self.epoch}')

            # 2.
            self.comfort()             # #reset the timer

            # 3.
            with self.lock_for['laid_down_history']:
                self.laid_down_history.clear()

            # 4.
            with self.lock_for['sig_of_nodes_to_be_added']:
                self.sig_of_nodes_to_be_added.clear()

            # 5.
            with self.lock_for['all_endpoints']:
                self.all_endpoints += newcomers

            # 6
            self.start_listening_as_sub()
            return 'Ok'

        self.say(f'Invalid certificate: {S.RED + o + S.NOR} from {S.CYAN + endpoint + S.NOR}, Do nothing')
        return 'No'

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

            """

            🦜 : How many laiddown do we need ?

            🐢 : Every correct node sends this, so there should be N - f 

            """
            x = self.N() - self.f()
            if len(valid_host) < x:
                self.say(f'Requires {S.CYAN} {x} {S.NOR} laiddown message{plural_maybe(x)}, but got {len(valid_host)}')
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
        self.net.listen('/pleaseExecuteThis', self.handle_execute_for_primary)

    def start_listening_as_sub(self):
        self.clear_and_listen_common_things()
        self.net.listen('/pleaseExecuteThis', self.handle_execute_for_sub)
        self.net.listen('/pleaseConfirmThis', self.handle_confirm_for_sub)

    def primary(self) -> str:
        "The current primary"
        return self.all_endpoints[self.epoch % len(self.all_endpoints)]

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
        with self.lock_for['command_history']:
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
                  We are currently selecting new primary for epoch {self.epoch + 1}.
                  Please try again later.
            """

        if endpoint == self.primary():
            self.add_to_to_be_confirmed_commands(self.net.listened_endpoint(),data)
            """🦜 : Boardcast to other subs"""

            # 🦜 : take out the endpoints, because self.primary() will also
            # lock 'all_endpoints'
            all_endpoints = None
            with self.lock_for['all_endpoints']:
                all_endpoints = self.all_endpoints

            self.say('\t\tBoardcasting cmd confirm')
            for sub in all_endpoints:
                if sub not in [self.net.listened_endpoint(), self.primary()]:
                    self.net.send(sub,'/pleaseConfirmThis',data)

            return 'OK'

        # forward, it's from the client
        self.net.send(self.primary(),'/pleaseExecuteThis',data)

        return 'OK'

    def add_to_to_be_confirmed_commands(self, endpoint:str, data:str) ->int:
        """Remember that endpoint `received` data.

        🦜 : Is this the only method that touch `self.to_be_confirmed_commands` ?

        🐢 : Looks so.
        """
        with self.lock_for['to_be_confirmed_commands']:
            if data not in self.to_be_confirmed_commands:
                self.say(f'Adding {S.MAG + data + S.NOR} from {S.MAG + endpoint + S.NOR}')
                self.to_be_confirmed_commands[data] = set({endpoint})
            else:
                # take one
                s: set[str] = self.to_be_confirmed_commands[data]
                s.add(endpoint)

                """

                🦜 : How many we should collect?

                🐢 : I think it should be N - 1 - f, 1 corresponds to the
                primary. For example, when N = 2, there should be one confirm
                (the one N1 put it after recieved the command). When N = 3,
                there should be two, (needs an extra one from N2).

                """
                if (len(s)) > self.N() - 1 - self.f():
                    self.say(f'⚙️ command {S.MAG + data + S.NOR} comfirmed by {len(s)} node{plural_maybe(len(s))}, executing it.')
                    self.exe.execute(data)
                else:
                    # return one
                    self.to_be_confirmed_commands[data] = s


    def handle_confirm_for_sub(self, endpoint: str, data: str) -> str:
        if self.view_change_state:
            return f"""
            Dear {endpoint}
                  We are currently selecting new primary for epoch {self.epoch + 1}.
                  Please try again later.
            """

        self.add_to_to_be_confirmed_commands(endpoint,data)
        return 'OK'

    def N(self) -> int:
        with self.lock_for['all_endpoints']:
            return len(self.all_endpoints)
    def f(self) -> int:
        """Get the number of random nodes the system can tolerate"""
        f = None
        with self.lock_for['all_endpoints']:
            N = len(self.all_endpoints)
            f = (N - 1) // 3        # number of random nodes
        return f

    def start_faulty_timer(self):
        """Life always has up-and-downs, but time moves toward Qian.

        🦜: The faulty timer is just a clock that keeps calling
        trigger_view_change(). It will not be reset by anybody except a
        new-primary with a new-view-certificate.

        """
        while not self.closed:
            self.comfort()
            p = -1
            with self.lock_for['patience']:
                p = self.patience
            while p > 0:
                sleep(2)
                with self.lock_for['patience']:
                    self.patience -= 1
                    p = self.patience
                self.say(f' patience >> {p}, 🐢PR: {S.BLUE} {self.primary()} {S.NOR}')

            # here the patience is run off
            self.trigger_view_change()
            # 🦜 : We trigger the view-change and reset the patience.

        self.say('Timer closed')

    def comfort(self):          # reset timer
        with self.lock_for['patience']:
            self.patience = 5
            self.say(f'❄ patience set to = {self.patience}')

    # 🦜 : Different N for different f is:
    # f = 0 ⇒ N = 3f + 1 = 1
    # f = 1 ⇒ N = 3f + 1 = 4 (four nodes can tolerate 1)
    # f = 2 ⇒ N = 3f + 1 = 7 (7 nodes can tolerate 2)

    def trigger_view_change(self):
        """When a node triggers the view-change, it borad cast something like
        'I laid down with this state: {...} for view {0}'

        And others will listens to it.
        """
        self.epoch += 1
        self.say('ViewChange triggered')
        self.view_change_state = True

        next_primary = self.primary()

        o = {
            'msg' : f'Dear {next_primary}, I laid down for U',
            'epoch' : self.epoch,
            'state' : self.get_state(),
            'from' : self.net.listened_endpoint()
        }
        data = self.sig.sign(json.dumps(o))

        # Send to next_primary the state of me
        if next_primary == self.net.listened_endpoint():
            self.say(S.MAG + 'Send laiddown for myself' + S.NOR)
            self.remember_this_laiddown_and_be_primary_maybe(o,data)
        else:
            self.net.send(next_primary,'/ILaidDown',data)

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
            next_primary = None
            with self.lock_for['all_endpoints']:
                next_primary = self.all_endpoints[o['epoch'] % len(self.all_endpoints)]
            if next_primary != self.net.listened_endpoint():
                self.say(f'🚮️ This view-change is non of my bussinesses: {o}')
                return 'No'

            self.remember_this_laiddown_and_be_primary_maybe(o,data)
        except json.JSONDecodeError as e:
            self.say(f'Error parsing msg: {data}')
            return 'No'

    def remember_this_laiddown_and_be_primary_maybe(self, o,data):
        """Add the laid-down msg `o` for this node into laid_down_history and
        if enough laid-down msg is collected, then be the primary.

        `data` should be the signed form of `o`:

        data = self.sig.sign(json.dumps(o))

        """
        state: str = o['state']
        epoch = o['epoch']
        to_be_added_list : list[str] = None

        with self.lock_for['laid_down_history']:
            # 🦜 : 1. Does this epoch already has something ? If not, create a new dict{}
            if epoch not in self.laid_down_history:
                self.say(f'\tAdding new record in laid_down_history for epoch {S.CYAN}{o["epoch"]}{S.NOR}')
                self.laid_down_history[epoch] = dict({})

            # 🦜 : 2. Does this epoch already got state like this ? If not, create a new list[]
            if state not in self.laid_down_history[epoch]:
                self.say(f'\t\tAdding new record in laid_down_history for {S.CYAN} epoch={o["epoch"]} {S.NOR},state=>>{S.CYAN}{o["state"]}{S.NOR}<<')
                self.laid_down_history[epoch][state] : list[str] = []

            # 🦜 Now take the list:
            to_be_added_list = self.laid_down_history[epoch][state]

        # 🦜 : This is the list that data (signed msg) will be added in.
        if data in to_be_added_list:
            self.say(f'🚮️ Ignoring duplicated msg from {o["from"]}')
            return 'No'

        to_be_added_list.append(data)

        """
        🦜 : How many laiddown msg does one need to collect in order to be the new primary?

        🐢 : Every correct node will append to it even the next primary itself.
        so it's N - f.
        """
        x = self.N() - self.f()
        if len(to_be_added_list) >= x:
            self.say(f'\t\tCollected enough {S.CYAN}{len(to_be_added_list)} >= {x} {S.NOR} laid-down message{plural_maybe(len(to_be_added_list))}')
            self.try_to_be_primary(epoch,state,to_be_added_list)
        else:
            self.say(f'\t\tCollected {S.CYAN}{len(to_be_added_list)} < {x} {S.NOR}laid-down message{plural_maybe(len(to_be_added_list))}, not yet my time')
            # return it
            self.laid_down_history[epoch][state] = to_be_added_list

        # 🦜 : It is my bussinesses and the epoch is right for me. I am just
        # ganna get majority of same-state, and if I am not one of them...
        #
        # I will sync to one of them.
        #
        #🐢 : What if the node "doesn't let you synk to its state?"
        #
        #🦜 : Then I will keep trying all these 2f + 1 nodes

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
                 f'>>{ S.CYAN + self.get_state() + S.NOR}<<\n'+
                 'And the majority has state: \n' +
                 f'>>{ S.CYAN + state + S.NOR}<<\n'
                 )

        # It's my view
        with self.lock_for['all_endpoints']:
            #🐢 : If U call self.N() here, dead lock happens.
            assert self.all_endpoints[e % len(self.all_endpoints)] == self.net.listened_endpoint()

        if self.get_state() != state:
            raise Exception('I am different from other correct nodes. The '+
                            'cluster might contained too many random nodes.')

        """

        🐢 : Add those new nodes, and notify them that they are in. The things
        that needs to be sent to the newcomers are different from those sent to
        other subs. In particular, it needs to send 'cmds' to those newcomers
        too, in addition to what's sent to everybody.

        """

        sig_for_newcomers = None
        # pop the new commers
        with self.lock_for['sig_of_nodes_to_be_added']:
            sig_for_newcomers = list(self.sig_of_nodes_to_be_added)  # set to list
            self.sig_of_nodes_to_be_added.clear()
        newcomers : list[str] = self.get_newcommers(sig_for_newcomers)


        if len(newcomers) == 0:
            """
            🐢 : If there's no newcomer, then the life is much easier:
            We just need to boardcast the new-view-certificate.
            """
            m = {'msg' : f'Hi I am the primary now.',
                 'epoch' : e,
                 'new-view-certificate' : my_list,
                 'sig_of_nodes_to_be_added' : []}
            # board-cast the list,ignoring the result to existing subs
            # failed_count: int = 0
            self.epoch = e
            self.boardcast_to_others('/IamThePrimary',json.dumps(m))
        else:
            """🐢 : But if there're newcomers, then we have to do the
            following:

            1. Recalculate the 'to-be-updated' epoch such that this node is the
            new primary. In details, the new epoch should be

                self.epoch =  e + (e\\N) * len(newcomers)            (1)

            However, the current epoch (before calculation) should still be
            saved and passed over the network because the msgs in
            `new-viwe-certificate` will be verified against this epoch (🐢 : No
            worries, the subs will calculate the `to-be-updated epoch`
            themselves.)

            2. Boardcast to existing nodes the `self.sig_of_nodes_to_be_added`.
            The other nodes should be able to derive the `newcomers` from it.
            Inside this msg, the `sig_of_nodes_to_be_added` should contains the
            new nodes to be added, and the `epoch` should be the *old one* we just
            used. (🦜 : This epoch should be same as the one that appears in
            the new-view-certificate.)

            When sub nodes received this,
            it will first see that the
            `sig_of_nodes_to_be_added` (and the newcomers derived from it) is
            not empty. Next, it will verify the `new_view_certificate`
            according to the epoch passed.

            But then, it will set its epoch according to eqn (1).

            Just like the primary. (🦜 : So when passing things aroung over the
            network, they all talk about the 'low' epoch, but in fact they will
            update their epoch to equiation (1), 🐢 : Yes)

            3. Notify the newcomers. This is basically the same process as for
            the subs. It's just that 'cmds' will also be sent inside the msg.

            """
            # 1.
            self.epoch = self.epoch_considering_newcomers(e, len(newcomers))

            # 2.
            m = {'msg' : f'Hi I am the primary now.',
                 'epoch' : e,
                 'new-view-certificate' : my_list,
                 'sig_of_nodes_to_be_added' : sig_for_newcomers}
            self.boardcast_to_others('/IamThePrimary',json.dumps(m))

            # 3.
            with self.lock_for['all_endpoints']:
                self.all_endpoints += newcomers

            with self.lock_for['command_history']:
                "Append cmds in the new-view cert"
                m['cmds'] = self.command_history

            # Send them the msg, in particular: the cmds.
            for  newcomer in newcomers:
                self.net.send(newcomer,'/IamThePrimaryForNewcomer',json.dumps(m))

            # 🦜 : In fact, the above can all be called asynchronously.

        # be the primary
        self.say(f'\t\tEpoch set to {self.epoch}')
        self.start_listening_as_primary()


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

        with self.lock_for['all_endpoints']:
            for sub in self.all_endpoints:
                if sub != self.net.listened_endpoint():
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

    def say(self,s: str):
        """Say something """

        my_id = 'NewCommer'

        with self.lock_for['all_endpoints']:
            if self.net.listened_endpoint() in self.all_endpoints:
                my_id = self.all_endpoints.index(self.net.listened_endpoint())

        print_mt(f'{S.CYAN}\t[{my_id}]{S.NOR}: ' + s)

    def handle_add_new_node(self, endpoint: str, data: str) -> str:
        """Add a new node, this just remembers the add-new msg, which should
        have been signed by putting it into the self.sig_of_nodes_to_be_added.
        """

        with self.lock_for['sig_of_nodes_to_be_added']:
            self.sig_of_nodes_to_be_added.add(data)


        self.boardcast_to_others('/pleaseAddMeNoBoardcast',data)
        #    ^^ a set
        """ 🐢 : Using a set is ok, in fact only the next-primary needs to
        remember it, and it will boardcast it when becoming the new primary. At
        that time, it turns the set into a list.

        🦜 : Do we need to check the result ?

        🐢 : Technically, we do. And the majority should answer 'OK'

        """

        return 'OK'

    def boardcast_to_others(self, target : str, data: str):
        with self.lock_for['all_endpoints']:
            for node in self.all_endpoints:
                # board-cast-to-others
                if node != self.net.listened_endpoint():
                    self.net.send(node,target,data)

    def handle_add_new_node_no_boardcast(self, endpoint: str, data: str) -> str:
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

        newcomers : list[str] = self.get_newcommers(d['sig_of_nodes_to_be_added'])
        with self.lock_for['all_endpoints']:
            self.all_endpoints += newcomers

        if self.net.listened_endpoint not in self.all_endpoints:
            raise Exception('What ? I am not added by the new view?')

        for cmd in d['cmds']:
            self.exe.execute(cmd)

        e = o['epoch']
        self.epoch = self.epoch_considering_newcomers(e, len(newcomers))
        self.say(f'🐸 view changed to {self.epoch}')

        Thread(target=self.start_faulty_timer).start()  # here where the new node are added
        self.start_listening_as_sub()

        return 'ok'

    def epoch_considering_newcomers(self, e, num_newcomers) -> int:
        """The equivalent epoch number when there're newcomers.

        🦜 : Note that when there's no newcomers, then it's just e.

        """
        return e + (e // self.N()) * num_newcomers




#--------------------------------------------------
"""
🦜 :Below we try to use the PBFT
"""

class MockedExecutable(IExecutable):
    def __init__(self, i: str):
        self.id = i
    def execute(self,command: str):
        print_mt(f'🦜 {S.RED} [{self.id}] Exec: {command} {S.NOR}')


network_hub : dict[str, Callable[[str,str],Optional[str]]] = dict()
lock_for_netwok_hub = Lock()
class MockedAsyncEndpointNetworkNode(IAsyncEndpointBasedNetworkable):
    def __init__(self,e: str):
        self.endpoint = e
    def listened_endpoint(self) -> str:
        return self.endpoint
    def listen(self,
               target: str,
               handler: Callable[[str,str],Optional[str]]
               ):
        k = f'{self.endpoint}-{target}'
        print_mt(f'Adding handler: {k}')
        with lock_for_netwok_hub:
            network_hub[k] = handler

    def clear(self):                # clears up all the listeners
        """🦜 : In fact there's no role-change in ListenToOneConsensus,
        therefore no ones is gonna call this."""
        with lock_for_netwok_hub:
            for k in list(network_hub.keys()):
                if k.startswith(f'{self.endpoint}-'):
                    print_mt(f'Removing handler: {k}')
                    network_hub.pop(k)

    def send(self,e: str, target: str, data: str):
        k = f'{e}-{target}'
        print_mt(f'{S.CYAN} Calling handler: {k} {S.NOR} with data:\n {S.CYAN} {data} {S.NOR}')
        with lock_for_netwok_hub:
            if k in network_hub:
                print_mt(f'Handler {k} found')
                Thread(target=network_hub[k],args=(self.endpoint,data)).start()
            else:
                print_mt(f'Handler {k} not found')

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
#         n = MockedAsyncEndpointNetworkNode(s)

#         if i == 0:
#             self.nodes[s] = ListenToOneConsensus(n=n,e=e)
#             self.primary_name = s
#             return
#         self.nodes[s] = ListenToOneConsensus(n=n,e=e,nodeToConnect=self.primary_name)

# fac = NodeFactory()
# for i in range(3): fac.make_node()

nClient = MockedAsyncEndpointNetworkNode('ClientAAA')

# make one node-cluster
s = 'N0'
e = MockedExecutable(s)
sg = MockedSigner(s)
n = MockedAsyncEndpointNetworkNode(s)
all_endpoints = [s]
nd = PbftConsensus(n=n,e=e,s=sg,all_endpoints=all_endpoints)


# Start the cluster
while True:
    # reply = input('Enter cmd: <id> <cmd>')
    reply = input('Enter: ')
    if reply == 'stop':
        break
    l = reply.split(' ')

    print_mt(f'{S.HEADER} Sending {l[1]} to {l[0]} {S.NOR}')
    nClient.send(l[0],'/pleaseExecuteThis',l[1])

print('Program stopped.')
