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
from abc import ABC, abstractmethod

class IExecutable(ABC):
    @abstractmethod
    def execute(self,command: str):
        pass

class IStaticIdBasedNetworkable(ABC):
    @abstractmethod
    def listen(self,
               target: str,
               handler: Callable[[int,str],Optional[str]]
               ):
        pass
    @abstractmethod
    def my_id(self) -> int:
        pass
    @abstractmethod
    def all_ids(self) -> list[int]:
        pass
    @abstractmethod
    def send(self,i: int, target: str, data: str) -> Optional[str]:
        # i: the target, e.g. 2
        # target: e.g. "/hi"
        pass
    @abstractmethod
    def clear(self):                # clears up all the listeners
        pass

class RaftConsensus:
    def __init__(self,
                 n: IStaticIdBasedNetworkable,
                 e: IExecutable):
        self.net = n
        self.exe = e
        self.lock_for_patience = Lock()
        self.primary = None
        self.dynasty = 0
        self.voted_dynasty = dict()

        self.start_listening_as_follower()

    def start_listening_as_follower(self):

        self.say('Started as follower')
        self.net.clear()
        self.net.listen('/pleaseAppendEntry', self.handle_append_entry)
        self.net.listen('/pleaseExecute', self.handle_execute)
        self.net.listen('/pleaseVoteMe', self.handle_ask_for_vote)
        self.net.listen('/IamThePrimary', self.handle_primary)

        Thread(target=self.start_internal_clock).start()  # here the ctor ends

    def start_internal_clock(self):
        self.comfort()

        p = -1
        with self.lock_for_patience:
            p = self.patience

        while p > 0:
            sleep(2)
            with self.lock_for_patience:
                self.patience -= 1
                p = self.patience
            self.say(f' patience >> {self.patience}, 🐢PR: {self.primary}')

        self.have_enough()

    def have_enough(self):
        self.say(f' have had enough')
        self.ask_for_votes()

    def handle_append_entry(self, i: int, d: str) -> Optional[str]:
        if i == self.primary:
            self.comfort()
            self.exe.execute(d)     # only primary will append entry
            return f"""
            Dear {i}, the primary
                 I have appended your requested entry. ✅️ {d}
                        Yours {self.net.my_id()}
            """
        return f"""
        Sorry, {i} ❌️
             My primary is {self.primary}, and I will only listen to him/her.
                Regards {self.net.my_id()}
        """

    def comfort(self):          # reset timer
        with self.lock_for_patience:
            self.patience = random.randrange(start=10,stop=20,step=2)
            self.say(f'patience set to = {self.patience}')

    def say(self,s: str):
        print_mt(f'[{self.net.my_id()}]: ' + s)

    def ask_for_votes(self):
        self.dynasty += 1
        self.voted_dynasty[self.dynasty] = self.net.my_id()
        c : int = 1
        for i in [i for i in self.net.all_ids() if i != self.net.my_id()]:
            r: str = self.net.send(i,'/pleaseVoteMe',f"""
            Hi {i}, vote me in the
               {self.dynasty}
                     compaign
                       Yours, {self.net.my_id()}
            """)
            if (r and r.startswith('Yes')):
                c += 1

        if c >= len(self.net.all_ids()) / 2:
            self.start_listening_as_primary(c)
        else:
            self.start_listening_as_follower()

    def start_listening_as_primary(self, c: int):
        self.primary = self.net.my_id()

        self.say(f'Listening as primary')
        for i in [i for i in self.net.all_ids() if i != self.net.my_id()]:
            self.net.send(i,'/IamThePrimary',f"""
            Hi, I got {c} votes to be the new primary,{self.net.my_id()}
                the dynasty number is:
                   {self.dynasty}
                               Regards {self.net.my_id()}
            """)

        self.net.clear()
        self.net.listen('/pleaseExecute',self.handle_execute_for_primary)



        # Make the following a thread
        self.alive = True
        Thread(target=self.heart_beat).start()

    def heart_beat(self):
        while self.alive:
            sleep(6)
            self.say(f'[Primary 💙]')
            for i in [i for i in self.net.all_ids() if i != self.net.my_id()]:
                self.net.send(i,'/pleaseAppendEntry','Beep')


    def handle_ask_for_vote(self, i: int, d: str) -> Optional[str]:
        self.primary = None
        self.comfort()
        asked_dynasty = int(d.splitlines()[2].strip())
        if asked_dynasty not in self.voted_dynasty:
            self.voted_dynasty[asked_dynasty] = i
            return 'Yes'
        return f"""Sorry,
              I have already voted for this term for
                     {self.voted_dynasty[asked_dynasty]}
                               Regards {self.net.my_id()}
        """

    def handle_primary(self, i: int, d: str) -> Optional[str]:
        self.primary = i
        self.dynasty = int(d.splitlines()[3].strip())
        return f"""
        Dear primary {i},
             from now on I will listen to you in term {self.dynasty}.
                      Regards {self.net.my_id()}
        """

    def handle_execute(self, i: int, d: str) -> Optional[str]:
        if self.primary == None:
            return f"""
            Dear client {i},
                Sorry, our group is electing primary for the moment,
                please try again latter.
                    Regards {self.net.my_id()}
            """
        return self.net.send(self.primary,'/pleaseExecute',d)  # forward

    def handle_execute_for_primary(self, i: int, d: str) -> Optional[str]:
        self.say(f'Primary executing {d}')
        self.exe.execute(d)
        subs = [s for s in self.net.all_ids() if s != self.net.my_id()]
        self.say(f'Asking subs: {subs}')
        for sub in subs:
            self.say(f'Ask {sub} to execute {d}')
            self.net.send(sub,'/pleaseAppendEntry',d)
            # Thread(target=
            #        lambda : 
            #        ).start()
        return f"""
        Dear client,
             Your requests {d} have been executed by our group
                  Regards {self.net.my_id()}, the primary
        """

class MockedExecutable(IExecutable):
    def __init__(self, i: int):
        self.id = i
    def execute(self,command: str):
        print_mt(f'🦜 {S.RED} [{self.id}] Exec: {command} {S.NOR}')


class MockedIdNetworkNode(IStaticIdBasedNetworkable):

    def __init__(self,i:int):
        self.id = i

    def my_id(self) -> int:
        return self.id
    def all_ids(self) -> list[int]:
        return network_nodes
    def send(self,i: int, target: str, data: str) -> Optional[str]:
        k = f'{i}-{target}'
        print_mt(f'{S.CYAN} Calling handler: {k} {S.NOR} with data:\n {S.CYAN} {data} {S.NOR}')
        if k in network_hub:
            r = network_hub[k](self.id,data)
        else:
            print_mt(f'Handler {k} not found')
            r = None
        print_mt(f'Got result:{S.GREEN} {r} {S.NOR}')
        return r

    def clear(self):                # clears up all the listeners
        with lock_for_netwok_hub:
            for k in list(network_hub.keys()):
                if k.startswith(f'{self.id}-'):
                    print_mt(f'Removing handler: {k}')
                    network_hub.pop(k)

    def listen(self,
               target: str,
               handler: Callable[[int,str],Optional[str]]
               ):
        k = f'{self.id}-{target}'
        print_mt(f'Adding handler: {k}')
        network_hub[k] = handler


network_hub : dict[str, Callable[[int,str],Optional[str]]] = dict()
lock_for_netwok_hub = Lock()
network_nodes = list(range(3))

network_iface = [MockedIdNetworkNode(i) for i in network_nodes]
executor_iface = [MockedExecutable(i) for i in network_nodes]
consensus_nodes = [
    RaftConsensus(network_iface[i],executor_iface[i]) for i in network_nodes
]

"""🦜 : The MockedIdNetworkNode is kinda like a 'view' for the network hub.
all NetworkNode share a common hub, so don't try to make the network hub local.
"""

nClient = MockedIdNetworkNode(1234)
while True:
    # reply = input('Enter cmd: <id> <cmd>')
    reply = input('Enter: ')
    if reply == 'stop': break

    l = reply.split(' ')

    # Simulate a dead node
    if l[0] == 'down':
        i = int(l[1])
        print_mt(f'{S.HEADER} Turning down node-{i} {S.NOR}')
        consensus_nodes[i].net.clear()
        consensus_nodes[i].alive = False
    else:
        # Execute a command
        i = int(l[0])
        print_mt(f'{S.HEADER} Sending {l[1]} to node-{i} {S.NOR}')
        nClient.send(i,'/pleaseExecute',l[1])

print(f'🐸 Bye')
