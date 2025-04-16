# Docker Setup for OpenManus

This guide explains how to use Docker to run the OpenManus project. The Docker setup simplifies the installation process by packaging all dependencies in a containerized environment.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/) (included with Docker Desktop for Windows and Mac)
- For GPU support: [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) (for Linux)

## Files Included

1. `Dockerfile` - Contains instructions to build the Docker image
2. `docker-compose.yml` - Configuration for running the containerized application
3. `.dockerignore` - Specifies files to exclude from the Docker build context

## Getting Started

### 1. Place the Docker Files in Your Project

Place the `Dockerfile`, `docker-compose.yml`, and `.dockerignore` files in the root directory of your OpenManus project.

### 2. Build and Start the Container

```bash
# Build the Docker image
docker-compose build

# Start the container
docker-compose up -d
```

### 3. Access the Application

- If OpenManus uses a Gradio web interface, access it at: http://localhost:7860
- If OpenManus provides an API server, access it at: http://localhost:8000

### 4. Execute Commands Inside the Container

To run commands inside the running container:

```bash
docker-compose exec openmanus bash
```

This opens a bash shell inside the container where you can run Python scripts or other commands.

## Customization

### Modify Environment Variables

Edit the `environment` section in `docker-compose.yml` to add or change environment variables.

### GPU Support

To enable GPU support:

1. Uncomment the `deploy` section in `docker-compose.yml`
2. Make sure you have the NVIDIA Container Toolkit installed (Linux only)

### Change Entry Point

Modify the `command` in `docker-compose.yml` to change the entry point script that runs when the container starts.

## Stopping the Container

```bash
# Stop the container but preserve data
docker-compose down

# Stop the container and remove volumes (data)
docker-compose down -v
```

## Troubleshooting

### CUDA Issues

If you encounter CUDA-related errors:

1. Verify that your NVIDIA drivers are correctly installed
2. Check that the CUDA version in the Dockerfile matches your host system's CUDA compatibility

### Permission Issues

If you encounter permission problems with mounted volumes:

```bash
# Fix permission issues by running the container as your user
USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose up -d
```

Add the following to your `docker-compose.yml` file under the `openmanus` service:

```yaml
user: "${USER_ID:-1000}:${GROUP_ID:-1000}"
```

## Additional Configuration

### Persistent Storage

The `docker-compose.yml` file configures two mounted volumes:

- `./:/app` - Mounts the current directory to `/app` in the container for development
- `./data:/app/data` - Mounts a data directory for persistent storage

Modify these paths as needed for your project structure.
