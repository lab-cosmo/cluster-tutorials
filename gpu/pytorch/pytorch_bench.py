import time
import torch
import torch.utils.benchmark as benchmark
from itertools import product

def batched_dot_mul_sum(a, b):
    '''Computes batched dot by multiplying and summing'''
    return a.mul(b).sum(-1)


def batched_dot_bmm(a, b):
    '''Computes batched dot by reducing to bmm'''
    a = a.reshape(-1, 1, a.shape[-1])
    b = b.reshape(-1, b.shape[-1], 1)
    return torch.bmm(a, b).flatten(-3)



# Compare takes a list of measurements which we'll save in results.
results = []
# 40000 seems to come close to the maximum memory 22698MiB GPU memory
sizes = [32, 1024, 4096, 8192, 16384, 32768, 40000]
for size in sizes:
    print(f"Starting benchmark with size={size}", flush=True)
    time.sleep(5)
    # label and sub_label are the rows
    # description is the column
    label = 'Batched dot'
    sub_label = f'[{size}, {size}]'
    x = torch.randn(size, size, device='cuda') # set device to run on GPU
    results.append(benchmark.Timer(
        stmt='batched_dot_mul_sum(x, x)',
        setup='from __main__ import batched_dot_mul_sum',
        globals={'x': x},
        num_threads=1, # CPU threads
        label=label,
        sub_label=sub_label,
        description='mul/sum',
    ).blocked_autorange(min_run_time=1))
    results.append(benchmark.Timer(
        stmt='batched_dot_bmm(x, x)',
        setup='from __main__ import batched_dot_bmm',
        globals={'x': x},
        num_threads=1, # CPU threads
        label=label,
        sub_label=sub_label,
        description='bmm',
    ).blocked_autorange(min_run_time=1))

compare = benchmark.Compare(results)
compare.print()
