from collections.abc import Callable
class IExecutable:
    def execute(self,command: str):
        pass

class IStaticIdBasedNetworkable:
    def listen(self,
               target: str,
               handler: Callable[[int,str],Optional[str]]
               ):
        pass
    def my_id() -> int:
        pass
    def all_ids() -> list[int]:
        pass
    def send(self,i: int, target: str, data: str) -> Optional[str]:
        # i: the target, e.g. 2
        # target: e.g. "/hi"
        pass

import threading
from threading import Thread, Timer
import random
# from random import randrange
from time import sleep
class RaftConsensus:
    def __init__(self,
                 n: IStaticIdBasedNetworkable,
                 e: IExecutable):
        self.net = n
        self.exe = e

        self.start_listening_as_follower()
    def start_listening_as_follower(self):
        patience = random.uniform(5,10)
        print(f'node-{self.net.my_id()} has patience {patience}')
        self.internal_clock = Timer(patience,function=have_enough,args=(self,))

        self.net.listen('/pleaseAppendEntry', self.handle_append_entry)
        self.net.listen('/pleaseVoteMe', self.handle_ask_for_vote)

        self.internal_clock.start()


    def have_enough(self):
        print(f"node-{self.net.my_id()} has had enough")
        self.ask_for_votes()

    def handle_append_entry(self, i: int, d: str) -> Optional[str]:
        self.comfort()
        self.exe.execute(d)     # only primary will append entry
        return f"""
        Dear {i}, the primary
             I have appended your requested entry.
                    Yours {self.net.my_id()}
        """

    def comfort(self):          # reset timer
        self.internal_clock.cancel()
        patience = random.uniform(5,10)
        print(f'node-{self.net.my_id()} has been consoled and got new patience {patience}')
        self.internal_clock = Timer(patience,function=have_enough,args=(self,))
        self.internal_clock.start()

    def ask_for_votes():
        pass
    def handle_ask_for_vote():
        pass
