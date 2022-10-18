x = 1

class C():
    x = globals()['x']
    y = globals().get('y', None)
    print(f"x is {x}")
    print(f"y is {y}")
    def __init__(self):
        print(f"x is {C.x}")
        print(f"y is {C.y}")

c = C()
# x is 1
