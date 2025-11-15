#!/bin/bash

# Copy notebooks to /data if they don't exist
if [ ! -f /data/basic_training_notebook.ipynb ]; then
    cp /root/basic_training_notebook.ipynb /data/
fi

if [ ! -f /data/advanced_training_notebook.ipynb ]; then
    cp /root/advanced_training_notebook.ipynb /data/
fi

# Create symlink to piper-sample-generator if it doesn't exist
if [ ! -e /data/piper-sample-generator ]; then
    ln -s /opt/piper-sample-generator /data/piper-sample-generator
fi

exec "$@"
