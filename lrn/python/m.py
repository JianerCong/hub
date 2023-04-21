import bpy
import random

def randf(lo,hi):
    return random.uniform(lo,hi)

def randi(lo,hi):
    return random.randint(lo,hi)

def gauss(mean,stdev):
    return random.gauss(mean,stdev)

bpy.app.driver_namespace['randf'] = randf
bpy.app.driver_namespace['randi'] = randi
bpy.app.driver_namespace['gauss'] = gauss
