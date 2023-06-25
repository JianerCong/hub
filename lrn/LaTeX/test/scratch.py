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
    def send(self,endpoint: str, target: str, data: str) -> Optional[str]:
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
        r = self.net.send(self.primary,
                    '/pleaseAddMe',
                    self.n.listened_endpoint())
        if not r:
            raise Exception('Failed to join the group')
        # In response, the primary should send you the history .
        cmd = r.split('\n')[3]  # forth line is the command
        if cmd:
            self.exe.execute(cmd)

    def start_listening_as_primary(self):
        self.known_subs = []
        self.command_history = []
        self.net.listen('/pleaseAddMe',
                        self.handle_add_new_node)
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_primary)

    def handle_add_new_node(self,sub_endpoint: str,
                            data: str) -> str:
        """[For primary] to add new node"""
        self.known_subs.append(sub_endpoint)
        return f"""
        Dear {sub_endpoint}
            You are in. and here is what we have so far:
            {''.join(self.command_history)}
                   Sincerely
                   {self.net.listened_endpoint()}, The primary.
        """

    def handle_execute_for_primary(self, endpoint: str,
                                   data: str) -> str:
        cmd = data
        self.command_history.append(cmd)
        self.exe.execute(cmd)
        for sub in self.known_subs:
            r = self.net.send(sub,'/pleaseExecuteThis',cmd)
            if not r:
                print(f'Node-{sub} is down,kick it off the group.')
                self.known_subs.remove(sub)

        return f"""
        Dear {endpoint}
             Your request has been carried out by our group.
             Members: {self.known_subs}
                 Sincerely
                 {self.net.listened_endpoint()}, The primary.
        """
    def start_listening_as_sub(self):
        self.net.listen('/pleaseExecuteThis',
                        self.handle_execute_for_sub)
    def handle_execute_for_sub(self,endpoint: str,data: str) -> str:
        cmd = data
        if (endpoint == self.primary):
            self.exe.execute(cmd)
            return f"""
            Dear boss,
                 Mission accomplished.
                     Sincerely
                     {self.net.listened_endpoint()}
            """
        else:
            # forward
            r = self.net.send(self.primary,
                                 '/pleaseExecuteThis',data)
            if not r:
                raise Exception('failed to forward message to primary')
            return r
