import asyncio
from threading import Thread


class EchoServerProtocol:
    def connection_made(self, transport):
        self.transport = transport

    def datagram_received(self, data, addr):
        message = data.decode()
        print('Received %r from %s' % (message, addr))
        """🐢 : Here we don't even send the result back.
        """

    def connection_lost(self,exc):
        if exc is None:
            print('Connection lost/closed()')
        else:
            print('Connection lost with exception.')


async def main():
    print("Starting UDP server")

    # Get a reference to the event loop as we plan to use
    # low-level APIs.
    loop = asyncio.get_running_loop()

    # One protocol instance will be created to serve all
    # client requests.
    transport, protocol = await loop.create_datagram_endpoint(
        lambda: EchoServerProtocol(),
        local_addr=('127.0.0.1', 7777))

    """🦜 : What's the difference between asyncio.sleep() and time.sleep() ?

    🐢 : asyncio.sleep() suspends the current task, allowing other tasks to run.
    """

    async def wait_until_get():
        s = ''
        def my_input():
            nonlocal s
            s = input('Enter anything to quit\n')
            print(f'Got input {s}')

        Thread(target=my_input).start()  # here the ctor ends
        while True:
            await asyncio.sleep(1)  # only here can other tasks be run
            if s != '':
                print('finished')
                return

    await wait_until_get()
    transport.close()


asyncio.run(main())
