# Docker Build Instructions for RTX 5080 Support

## If you encounter "parent snapshot does not exist" error:

This is a Docker layer cache issue. Try these solutions in order:

### Solution 1: Build with --no-cache
```bash
docker build --no-cache -t microwakeword-custom-trainer .
```

### Solution 2: Prune Docker system and rebuild
```bash
docker system prune -a
docker build -t microwakeword-custom-trainer .
```

### Solution 3: Check disk space
```bash
# On Windows (PowerShell)
Get-PSDrive C

# Make sure you have at least 20GB free
```

### Solution 4: Restart Docker Desktop
- Right-click Docker Desktop tray icon
- Select "Quit Docker Desktop"
- Start Docker Desktop again
- Retry the build

## Recommended Build Command

```bash
docker build --no-cache -t microwakeword-custom-trainer .
```

## Run the Container

Once built successfully:
```bash
docker run --rm -it --gpus all -p 8888:8888 -v ${PWD}:/data microwakeword-custom-trainer
```

On Windows:
```bash
docker run --rm -it --gpus all -p 8888:8888 -v C:\Users\YourUsername\microWakeWord-Custom-Trainer:/data microwakeword-custom-trainer
```
