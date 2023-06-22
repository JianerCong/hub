from collections.abc import Callable
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
    def listened_endpoint() -> str:
        pass
    def send(self,endpoint: str, target: str) -> str:
        # endpoint: the target, e.g. "localhost:8080"
        # target: e.g. "/hi"
        pass


class IExecutable:
    def execute(self,command: str):
        pass

class ListenToOneConsensus:
    def __init__(self,
                 n: IEndpointBasedNetworkable,
                 e: IExecutable,
                 nodeToConnect=''):
        self.net = n
        self.exe = e
        if nodeToConnect:
            self.primary = nodeToConnect
            self.is_primary = false
            self.ask_primary_for_entry()
            self.start_listening_as_sub()
        else:
            self.is_primary = true
            self.start_listening_as_primary()

    def ask_primary_for_entry(self):
        r = self.n.send(self.primary,
                    '/pleaseAddMe',
                    self.n.listened_endpoint())
        # In response, the primary may ask you to execute something.
        if r:
            self.exe.execute(r)
    
