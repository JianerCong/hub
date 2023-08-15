import asyncio


class EchoClientProtocol:
    def __init__(self, message, on_con_lost):
        self.message = message
        self.on_con_lost = on_con_lost
        self.transport = None

    def connection_made(self, transport):
        self.transport = transport
        print('Send:', self.message)
        self.transport.sendto(self.message.encode())
        # 🦜 : Here we just send a message and stop.
        self.transport.close()
        """

        🦜 : Will this flush the buffer to be sent ?

        🐢 : Yes. If the transport has a buffer for outgoing data, buffered
        data will be flushed asynchronously.

        No more data will be received. After all buffered data is flushed, the
        protocol’s protocol.connection_lost() method will be called with None
        as its argument.

        The transport should not be used once it is closed. """

    def error_received(self, exc):
        print('Error received:', exc)
        self.transport.close()

    def connection_lost(self, exc):
        print("Connection closed")
        self.on_con_lost.set_result(True)


async def main():
    # Get a reference to the event loop as we plan to use
    # low-level APIs.
    loop = asyncio.get_running_loop()

    on_con_lost = loop.create_future()
    message = "aaa"

    transport, protocol = await loop.create_datagram_endpoint(
        lambda: EchoClientProtocol(message, on_con_lost),
        remote_addr=('127.0.0.1', 7777))

    try:
        await on_con_lost
    finally:
        transport.close()


asyncio.run(main())
