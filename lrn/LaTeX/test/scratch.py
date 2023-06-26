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

class RaftConsensus:
    def __init__(self,
                 n: IStaticIdBasedNetworkable,
                 e: IExecutable):
        self.net = n
        self.exe = e

        self.start_listening_as_follower()
    def start_listening_as_follower(self):
        pass

