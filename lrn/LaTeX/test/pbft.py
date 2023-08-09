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
partucular msg sent by other nodes. For example, N1 needs to show N2 that
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
# 
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
        self.recieved_commands: set[str] = {}  # recieved by primary
        self.command_history: list[str] = []  # executed

        self.net.listen('/pleaseGiveMeUrCmds',self.handle_give_cmds)

        if self.primary() == self.net.listened_endpoint():
            self.start_listening_as_primary()
        else:
            self.start_listening_as_sub()

        self.start_faulty_timer()


    def start_listening_as_primary(self):
        self.net.listen('/whatsYourState',
                        self.handle_get_state)
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_primary)

    def start_listening_as_sub(self):
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_sub)

    def primary(self) -> str:
        "The current primary"
        return self.all_endpoints[self.epoch % self.epoch]

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
            self.say(f' patience >> {self.patience}, 🐢PR: {S.BLUE} {self.primary} {S.NOR}')

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
        except Exception as e:
            self.say(f'Error parsing msg: {data}')
            return 'No'

    def try_to_be_primary(self,e: int,state: str, my_list: list[str]):
        self.say(f'This\'s my time for epoch :{e}, my state is: \n'+
                 '{ S.CYAN + self.get_state() + S.NOR} \n'+
                 'And the majority has state: \n' +
                 '{ S.CYAN + state + S.NOR} \n'
                 )

        if self.get_state() != state:
            raise Exception('I am different from other correct nodes. The '+
                            'cluster might contained too many random nodes.')

        # board-cast the list


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

        return self.epoch[-1] == self.net.listened_endpoint()

    def my_id(self) -> int:
        """Throw if not found"""
        return self.all_endpoints.index(self.net.listened_endpoint())

    def say(self,s: str):
        """Say something """
        print_mt(f'{S.CYAN}\t[{self.my_id()}]{S.NOR}: '
                  + s)
