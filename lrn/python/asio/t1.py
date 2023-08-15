import asyncio

"""🦜 Why asyncio ?

🐢 I think the key of asyncio is about 'sleep()'. Some thread sleep very often,
and during that time, it occupies a whole thread. That can be avoided. And
that's why asyncio is here.

"""

async def f1():
    print('111')
    await asyncio.sleep(2) # give control
    print('111')

async def f2():
    print('222')
    await asyncio.sleep(2) # give control
    print('222')

async def main():
    # make them run in parallel
    await asyncio.gather(f1(),f2())

# async def m_with_task_group():
#     "You can also use `task` to do currency (available in 3.11)"
#     async with asyncio.TaskGroup() as tg:
#         tg.

async def m_with_task():
    """🐢 :Task means 'concurrent corotines'

    """
    t1 = asyncio.create_task(f1())
    t2 = asyncio.create_task(f2())
    await t1
    print('awaiting a task doesn\'t block so I am after 111 and 222')
    await t2

async def m_linear():
    """🐢 :Task means 'concurrent corotines'

    """

    await f1()
    print('awaiting a corotine usually block, so I\'m between 111 and 222')
    await f2()

# asyncio.run(main())
asyncio.run(m_with_task())
# asyncio.run(m_linear())
