import os
import time

import numpy as np

import torch
import schnetpack as spk


QM9_DIRECTORY = os.getenv("QM9_DIRECTORY")
# defined by the server
MODEL_DIRECTORY = os.getenv("MODEL_DIRECTORY")
#import subprocess
#LOCALSCRATCH = os.getenv("LOCALSCRATCH")
# cp dataset to scratch
#subprocess.call(f"cp {QM9_DIRECTORY}qm9.db {LOCALSCRATCH}")

DEVICE = 'cuda'
N_EPOCHS = 3
PROPERTY_NAME = 'energy_U0'


# Downloading the dataset can result in problems because of certificate issues, so download it locally
# on your machine and copy it to the server
begin = time.time()
qm9data = spk.datasets.QM9(os.path.join(QM9_DIRECTORY, 'qm9.db'), download=False, load_only=[spk.datasets.QM9.U0], remove_uncharacterized=True)
end = time.time()
print(f"Time to begin SQL connection with dataset {end-begin} s", flush=True)

split_file = os.path.join(MODEL_DIRECTORY, "split.npz")
train_idx = np.arange(5000)
val_idx = np.arange(5000, 6000)
# for this example we will ignore the test set
test_idx = np.arange(7000, 8000)
np.savez(split_file, train_idx=train_idx, val_idx=val_idx, test_idx=test_idx)
train, val, test = spk.train_test_split(data=qm9data, split_file=split_file)

# load the whole dataset in one batch
train_loader = spk.AtomsLoader(train, batch_size=len(train_idx), shuffle=True)
val_loader = spk.AtomsLoader(val, batch_size=len(val_idx))

import itertools
# load into RAM
begin = time.time()
# first batch contains whole dataset
train_data = list(train_loader)[0]
val_data = list(val_loader)[0]
#train_data = {key: torch.cat([train_data[i][key] for i in range(len(train_data))], dim=0) for key in 'energy_U0'}
#train_data = {key: torch.cat([train_data[i][key] for i in range(len(train_data))], dim=0) for key in train_data[0].keys()}
#train_data = list(itertools.chain.from_iterable(train_loader))
#val_data = list(itertools.chain.from_iterable(val_loader))
end = time.time()
print(f"Time to load dataset into RAM {end-begin} s", flush=True)

model_file = os.path.join(MODEL_DIRECTORY, "split.npz")
schnet = spk.representation.SchNet(
    n_atom_basis=128, n_filters=128, n_gaussians=50, n_interactions=5,
    cutoff=10., cutoff_network=spk.nn.cutoff.CosineCutoff
)

output_U0 = spk.atomistic.Atomwise(n_in=128, n_out=1, n_neurons = 100,  property='energy_U0',
                                   aggregation_mode= 'avg')
model = spk.AtomisticModel(representation=schnet, output_modules=output_U0)
if DEVICE == 'cuda':
    model.cuda()
# build optimizer
optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer, factor= 0.5, verbose=False, cooldown=100, patience=50)

# loss function
def mae_loss(batch, result, property_name):
    return torch.mean(torch.abs(batch[property_name]-result[property_name]))

def iterate_minibatches(data, batchsize):
    # exact property name is not important, only length
    indices = np.random.permutation(np.arange(len(data['energy_U0'])))
    for start in range(0, len(indices), batchsize):
        result = {}
        for key in data.keys():
            result[key] = data[key][start: start + batchsize]
        yield result


epoch_timings = []
for epoch in range(N_EPOCHS):
    begin = time.time() 
    model.train(True)
    losses = []
    for batch in iterate_minibatches(train_data, 100):
        optimizer.zero_grad()
        train_batch = {k: v.to(DEVICE) for k, v in batch.items()}

        result = model(train_batch)
        loss = mae_loss(train_batch, result, PROPERTY_NAME)
        losses.append(loss.data.cpu().numpy())
        loss.backward()
        optimizer.step()

    model.train(False)
    losses = []
    ground_truth = []
    predicted = []
    for batch in iterate_minibatches(val_data, 100):
        val_batch = {k: v.to(DEVICE) for k, v in batch.items()}
        ground_truth.append(val_batch[PROPERTY_NAME].data.cpu().numpy().squeeze())
        result = model(val_batch)
        predicted.append(result[PROPERTY_NAME].data.cpu().numpy().squeeze())

        loss = mae_loss(val_batch, result, PROPERTY_NAME)
        losses.append(loss.data.cpu().numpy())

    ground_truth = np.vstack(ground_truth)
    predicted = np.vstack(predicted)
    scheduler.step(np.mean(losses))
    end = time.time()
    epoch_timings.append(end-begin)

print(f"Average epoch time {np.mean(epoch_timings)} s", flush=True)
