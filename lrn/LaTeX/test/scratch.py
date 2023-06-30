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

class IEndpointBasedNetworkable(ABC):
    @abstractmethod
    def listen(self,
               target: str,     # The target, e.g. "/"
               handler: Callable[[str,str],Optional[str]]
               # The handler, accepts
               #  - endpoint, e.g. "localhost:8080"
               #  - request data
               # returns the result
               ):
        pass
    @abstractmethod
    def listened_endpoint(self) -> str:
        pass
    @abstractmethod
    def send(self,endpoint: str, target: str, data: str) -> Optional[str]:
        # endpoint: the target, e.g. "localhost:8080"
        # target: e.g. "/hi"
        pass
    @abstractmethod
    def clear(self):                # clears up all the listeners
        pass

class IExecutable(ABC):
    @abstractmethod
    def execute(self,command: str) -> str:
        pass

class FollowMeConsensus:
    def __init__(self,
                 n: IEndpointBasedNetworkable,
                 e: IExecutable,
                 nodeToConnect=''):
        self.net: IEndpointBasedNetworkable = n
        self.exe = e

        # All nodes keep these two, but only the primary's and next-primary's
        # are valid.
        self.known_subs: list[str] = []
        self.command_history = []

        if nodeToConnect:
            self.primary = nodeToConnect
            self.ask_primary_for_entry()
            self.start_listening_as_sub()
            print_mt(f'{self.net.listened_endpoint()} started as sub 🐸')
        else:
            self.known_subs.append(self.net.listened_endpoint())
            print_mt(f'{self.net.listened_endpoint()} started as primary 🐸')
            self.start_listening_as_primary()

    def start_listening_as_primary(self):
        self.net.clear()
        self.net.listen('/pleaseAddMe',
                        self.handle_add_new_node)
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_primary)

    def handle_add_new_node(self,sub_endpoint: str, data: str) -> str:
        """[For primary] to add new node"""
        self.known_subs.append(sub_endpoint)
        self.sync_subs()

        return f"""
        Dear {sub_endpoint}
            You are in, and here is what we have so far:
            {','.join(self.command_history)}
            Our team has:
            {','.join(self.known_subs)}
                   Sincerely
                   {self.net.listened_endpoint()}, The primary.
        """

    def sync_subs(self):
        # Board-cast the add-node msg
        while True:

            ok = True
            for sub in self.known_subs[1:]:
                r =  self.net.send(sub,'/pleaseSyncColleage',
                                   ','.join(self.known_subs)
                                   )
                if r == None:
                    ok = False
                    print(f'sub {sub} is down, kick it out of the group')
                    self.known_subs.remove(sub)

            if ok:
                print(f'All nodes synced: {self.known_subs}')
                break

    def handle_execute_for_primary(self, endpoint: str,
                                   data: str) -> str:

        cmd = data
        self.command_history.append(cmd)
        self.exe.execute(cmd)
        for sub in self.known_subs:
            r = self.net.send(sub,'/pleaseExecuteThis',cmd)
            if r == None:
                print(f'❌️ Node-{sub} is down,kick it off the group.')
                self.known_subs.remove(sub)

        self.sync_subs()

        return f"""
        Dear client {endpoint}
             Your request has been carried out by our group.
             Members: {self.known_subs}
                 Sincerely
                 {self.net.listened_endpoint()}, The primary.
        """

    def ask_primary_for_entry(self):
        r = self.net.send(self.primary,
                    '/pleaseAddMe',f"""
                    Hi primary {self.primary},
                       please add me in the group
                          Regards {self.net.listened_endpoint()}
                    """
                          )
        if r == None:
            raise Exception('Failed to join the group')
        # In response, the primary should send you the history .
        res = r.split('\n')  # forth line is the command
        cmd = res[3].strip()
        if cmd!='':
            self.exe.execute(cmd)
        self.known_subs = res[5].split(',')

    def start_listening_as_sub(self):
        self.net.listen('/pleaseExecuteThis', self.handle_execute_for_sub)
        self.net.listen('/pleaseSyncColleage', self.handle_sync_colleage)
        self.net.listen('/pleaseBePrimary', self.handle_be_primary)
        self.net.listen('/pleaseBeMySub', self.handle_be_my_sub)

    def handle_sync_colleage(self,endpoint: str,data: str) -> str:
        self.known_subs = data.split(',')
        return """Dear {endpoint}:
                       I have sync my subs to :{self.known_subs}
                            Regards {self.net.listened_endpoint()}
        """

    def handle_be_my_sub(self,endpoint: str,data: str) -> str:
        """
        As long as one of the primary and next-primary is alive, the group should be okay.
        """
        while endpoint != self.known_subs[0]:
            if self.known_subs[0] == self.net.listened_endpoint():
                raise Exception('What? I,{self.net.listened_endpoint()} should be primary before {endpoint}')
            self.known_subs = self.known_subs[1:]  # pop front

        self.say(f'updating known_subs to {self.known_subs}')
        return 'Yes'

    def say(self,s: str):
        print_mt(f'[{self.net.listened_endpoint()}]: ' + s)

    def handle_be_primary(self,endpoint: str,data: str) -> str:
        while self.known_subs[0] != self.net.listened_endpoint():
            self.known_subs = self.known_subs[1:]  # pop front until I'm the sub

        self.say(f'updating known_subs to {self.known_subs}')

        for sub in self.known_subs:
            r = self.net.send(sub,'/pleaseBeMySub','')
            if r == None:
                print(f'❌️ Node-{sub} is down,kick it off the group.')
                self.known_subs.remove(sub)

        self.sync_subs()
        self.start_listening_as_primary()

    def handle_execute_for_sub(self,endpoint: str,data: str) -> str:
        cmd = data
        if (endpoint == self.primary):
            self.exe.execute(cmd)
            return f"""
            Dear boss {self.primary},
                 Mission [{data}] is accomplished.
                     Sincerely
                     {self.net.listened_endpoint()}
            """
        else:
            # forward
            r = self.net.send(self.primary,
                                 '/pleaseExecuteThis',data)
            if r == None:
                r = self.net.send(self.primary, '/pleaseExecuteThis',data)
                raise Exception('failed to forward message to primary')
            return r



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


from wonderwords import RandomWord
class NodeFactory:
    nodes: dict[str,ListenToOneConsensus] = dict()
    r = RandomWord()
    primary_name = ''
    def make_node(self):
        i = len(self.nodes)
        s = self.r.word(word_max_length=4)
        e = MockedExecutable(s)
        n = MockedEndpointNetworkNode(s)
        if i == 0:
            self.nodes[s] = ListenToOneConsensus(n=n,e=e)
            self.primary_name = s
            return
        self.nodes[s] = ListenToOneConsensus(n=n,e=e,
                                             nodeToConnect=self.primary_name)

fac = NodeFactory()
for i in range(3): fac.make_node()

nClient = MockedEndpointNetworkNode('ClientAAA')
while True:
    # reply = input('Enter cmd: <id> <cmd>')
    reply = input('Enter: ')
    if reply == 'stop': break
    if reply == 'append':
        print_mt(f'{S.HEADER} Appending node {S.NOR}')
        fac.make_node()
        continue
    l = reply.split(' ')
    if l[0] == 'kick':
        print_mt(f'{S.HEADER} Kicking node {l[1]} {S.NOR}')
        fac.nodes[l[1]].net.clear()
        continue

    print_mt(f'{S.HEADER} Sending {l[1]} to {l[0]} {S.NOR}')
    nClient.send(l[0],'/pleaseExecuteThis',l[1])
