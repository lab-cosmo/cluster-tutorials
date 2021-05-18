import os
import time
import subprocess

import numpy as np

import torch
import schnetpack as spk
from schnetpack.datasets import QM9


QM9_DIRECTORY = os.getenv("QM9_DIRECTORY")
# defined by the server
MODEL_DIRECTORY = os.getenv("MODEL_DIRECTORY")
# defined by the server
SCRATCH = os.getenv("SCRATCH")
# cp dataset to fast local scratch
subprocess.call(f"cp {os.path.join(QM9_DIRECTORY, 'qm9.db')} {SCRATCH}", shell=True)

DEVICE = 'cuda'
N_EPOCHS = 3
PROPERTY_NAME = 'energy_U0'


# Downloading the dataset can result in problems because of certificate issues, so download it locally
# on your machine and copy it to the server
begin = time.time()
qm9data = QM9(os.path.join(SCRATCH, 'qm9.db'), download=False, load_only=[QM9.U0], remove_uncharacterized=True)
end = time.time()
print(f"Time to begin SQL connection with dataset {end-begin} s", flush=True)

split_file = os.path.join(MODEL_DIRECTORY, "split.npz")
train_idx = np.arange(5000)
val_idx = np.arange(5000, 6000)
test_idx = np.arange(7000, 8000)
np.savez(split_file, train_idx=train_idx, val_idx=val_idx, test_idx=test_idx)
train, val, test = spk.train_test_split(data=qm9data, split_file=split_file)

train_loader = spk.AtomsLoader(train, batch_size=100, shuffle=True)
val_loader = spk.AtomsLoader(val, batch_size=100)

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

loss = spk.train.build_mse_loss([QM9.U0])

metrics = [spk.metrics.MeanAbsoluteError(QM9.U0)]
hooks = [
    spk.train.CSVHook(log_path=MODEL_DIRECTORY, metrics=metrics),
    spk.train.ReduceLROnPlateauHook(
        optimizer,
        patience=5, factor=0.8, min_lr=1e-6,
        stop_after_min=True
    )
]

trainer = spk.train.Trainer(
    model_path=MODEL_DIRECTORY,
    model=model,
    hooks=hooks,
    loss_fn=loss,
    optimizer=optimizer,
    train_loader=train_loader,
    validation_loader=val_loader,
)

begin = time.time()
trainer.train(device=DEVICE, n_epochs=N_EPOCHS)
end = time.time()
print(f"Average epoch time {(end-begin)/N_EPOCHS} s", flush=True)
subprocess.call(f"rm {os.path.join(SCRATCH, 'qm9.db')}", shell=True)
