import asyncio
from kademlia.network import Server

async def run():
    # Create a node and start listening on port 5678
    node = Server()
    node2 = Server()

    await node.listen(5678)
    await node2.listen(5679)

    # Bootstrap the node by connecting to other known nodes, in this case
    # replace 123.123.123.123 with the IP of another node and optionally
    # give as many ip/port combos as you can for other nodes.
    await node.bootstrap([("localhost", 5679)])
    # await node2.bootstrap([("localhost", 5678)])

    # set a value for the key "my-key" on the network
    await node.set("my-key", "my-value")

    # get the value associated with "my-key" from the network
    result = await node2.get("my-key")
    print(f'Value from node2 is {result}')

asyncio.run(run())
