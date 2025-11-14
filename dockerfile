# Use Ubuntu 22.04 as the base image (includes Python 3.10 by default)
FROM ubuntu:22.04

# Set environment variables for non-interactive installations and Python buffering
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies including Python 3.10 (default on 22.04)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl git unzip build-essential \
    libsndfile1 libffi-dev python3-dev python3-pip python3-venv \
    g++ cmake gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add NVIDIA's CUDA repository using keyring and install CUDA 12.8 Toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    apt-get update && \
    apt-get -y install cuda-toolkit-12-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* && \
    rm -f cuda-keyring_1.1-1_all.deb

# Install cuDNN (compatible with CUDA 12.8 and RTX 5080 support)
RUN apt-get update && \
    apt-get -y install cudnn-cuda-12 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/*

# Install Python dependencies from requirements.txt
ADD https://raw.githubusercontent.com/stujenn/microWakeWord-Custom-Trainer/refs/heads/main/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install PyTorch 2.7.1 with CUDA 12.8 support (required for RTX 5080 sm_120)
RUN python3.10 -m pip install --no-cache-dir torch==2.7.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/cu128

# Ensure numpy 2.0.2 is installed for Python 3.10 (required for numba 0.60.0 and RTX 5080)
RUN python3.10 -m pip install --no-cache-dir numpy==2.0.2

# Create a data directory for external mapping
RUN mkdir -p /data

# Copy the notebooks to a fallback location in the container
ADD https://raw.githubusercontent.com/stujenn/microWakeWord-Custom-Trainer/refs/heads/main/basic_training_notebook.ipynb /root/basic_training_notebook.ipynb
ADD https://raw.githubusercontent.com/stujenn/microWakeWord-Custom-Trainer/refs/heads/main/advanced_training_notebook.ipynb /root/advanced_training_notebook.ipynb

# Add the startup script from GitHub
ADD https://raw.githubusercontent.com/stujenn/microWakeWord-Custom-Trainer/refs/heads/main/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Ensure /data is the default directory for Jupyter
WORKDIR /data

# Expose the Jupyter Notebook port
EXPOSE 8888

# Run the startup script and start Jupyter Notebook
CMD ["/bin/bash", "-c", "/usr/local/bin/startup.sh && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token='' --notebook-dir=/data"]
