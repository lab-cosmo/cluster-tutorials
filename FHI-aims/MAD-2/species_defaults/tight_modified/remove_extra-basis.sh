#!/bin/bash

for file in *_default; do
    if [ -f "$file" ]; then
        # Only edit files that contain a line starting with "# confined"
        if grep -q "confined" "$file"; then
            sed -i 's/confined/# confined/' "$file"
            echo "Commented 'confined' in $file"
        fi
    fi
done
