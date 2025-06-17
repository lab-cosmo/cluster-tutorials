import os
from ase.io import read, write
from ase.data import atomic_numbers

# Read frames from a xyz trajectory file
frames = read('water.xyz',':')

control_template = open('../master_control.in').read()
basis_dir = '../species_defaults/tight_modified'


for i, atoms in enumerate(frames):

    frame_dir = f'frame_{i:05d}'
    os.makedirs(frame_dir, exist_ok=True)

    # 1. Write geometry.in
    geom_path = os.path.join(frame_dir, 'geometry.in')
    write(geom_path, atoms, format='aims')

    # 2. Prepare control.in
    symbols = sorted(set(atoms.get_chemical_symbols()))
    basis_blocks = []

    for sym in symbols:
        Z = atomic_numbers[sym]
        basis_file = f"{basis_dir}/{Z:02d}_{sym}_default"
        if os.path.exists(basis_file):
            with open(basis_file) as f:
                basis_blocks.append(f.read())
        else:
            print(f"Warning: Missing basis set for {sym} at {basis_file}")

    full_control = control_template + '\n\n' + '\n\n'.join(basis_blocks)
    with open(os.path.join(frame_dir, 'control.in'), 'w') as f:
        f.write(full_control)

    print(f"Prepared {frame_dir}")
