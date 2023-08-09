import threading
from threading import Thread, Timer, Lock
import random
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
    # extract part of the msg
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
                 all_endpoints : list[str]):
        self.net = n
        self.exe = e
        self.all_endpoints = all_endpoints
        self.epoch: list[str]  = [all_endpoints[0]]
        self.view_change_state = False

        self.command_history: list[str] = []  # executed

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

        if self.my_id() == 0:
            self.start_listening_as_primary()
        else:
            self.start_listening_as_sub()

    def start_listening_as_sub(self):
        pass

    def start_listening_as_primary(self):
        self.net.listen('/whatsYourState',
                        self.handle_get_state)
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_primary)

    def primary(self) -> str:
        return self.epoch[-1]

    def handle_get_state(self, endpoint: str, data: str) -> str:
        """Get the state of the current node, when asked by others."""
        return self.get_state()

    def get_state(self):
        """Get the (hash of) state, which should only be changed by the cmd
        executed so far.

        🦜 : Technically we should hash the commands history so far, but for now...

        🐢 : Let's just use:
        """
        ':'.join(self.command_history)

    def handle_execute_for_sub(self,endpoint: str,data: str) -> str:
        cmd = data
        if (endpoint == self.primary()):
            return handle_execute_from_primary(data)
            # self.exe.execute(cmd)
            # return f"""
            # Dear boss {self.primary},
            #      Mission [{data}] is accomplished.
            #          Sincerely
            #          {self.net.listened_endpoint()}
            # """
        else:
            # forward
            r = self.net.send(self.primary,
                                 '/pleaseExecuteThis',data)
            if r == None:
                self.trigger_view_change()
            return r

    def add_to_to_be_confirmed_commands(self, data:str) ->int:
        if data not in self.to_be_confirmed_commands:
            self.to_be_confirmed_commands[data] = 1
        else:
            n = self.to_be_confirmed_commands[data]
            if (n + 1 > 1):
                

    def handle_execute_from_primary(data: str):
        # put in the queue
        # self.

        if self.comfirm_with_others(data):


    def trigger_view_change(self):
        self.say('ViewChange triggered')
        self.view_change_state = True
        if self.check_I_am_the_next():
            self.say('I am the next, please start guys')

        # Else: do nothing, wait for the correct one to

    def check_I_am_the_next(self) -> bool:
        """Here we check the states with the cluster.

        This is 

        """
        return False

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
