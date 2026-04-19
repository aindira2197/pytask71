import random
import time
from memory_profiler import profile

@profile
def big_array():
    array = [random.randint(0, 100) for _ in range(1000000)]
    time.sleep(1)
    return array

@profile
def small_array():
    array = [random.randint(0, 100) for _ in range(1000)]
    time.sleep(1)
    return array

class MemoryProfiler:
    def __init__(self):
        self.memory_usage = []

    def start(self):
        self.start_time = time.time()

    def stop(self):
        self.end_time = time.time()
        self.memory_usage.append((self.end_time - self.start_time))

    def get_memory_usage(self):
        return self.memory_usage

profiler = MemoryProfiler()
profiler.start()
big_array()
profiler.stop()
print(profiler.get_memory_usage())

profiler = MemoryProfiler()
profiler.start()
small_array()
profiler.stop()
print(profiler.get_memory_usage())

class Object:
    def __init__(self):
        self.big_data = [random.randint(0, 100) for _ in range(1000000)]

    def get_data(self):
        return self.big_data

@profile
def object_creation():
    obj = Object()
    time.sleep(1)
    return obj

obj = object_creation()
print(len(obj.get_data()))

@profile
def list_comprehension():
    data = [random.randint(0, 100) for _ in range(1000000)]
    time.sleep(1)
    return data

data = list_comprehension()
print(len(data))

@profile
def for_loop():
    data = []
    for _ in range(1000000):
        data.append(random.randint(0, 100))
    time.sleep(1)
    return data

data = for_loop()
print(len(data))

@profile
def dict_creation():
    data = {i: random.randint(0, 100) for i in range(1000000)}
    time.sleep(1)
    return data

data = dict_creation()
print(len(data))

@profile
def set_creation():
    data = {random.randint(0, 100) for _ in range(1000000)}
    time.sleep(1)
    return data

data = set_creation()
print(len(data))