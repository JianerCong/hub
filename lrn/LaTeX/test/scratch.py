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
    def send(self,endpoint: str, target: str) -> str:
        # endpoint: the target, e.g. "localhost:8080"
        # target: e.g. "/hi"
        pass


class IExecutable:
    def execute(self,command: str):
        pass
