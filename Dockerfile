# Base image with CUDA support for GPU acceleration (if needed)
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    wget \
    curl \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /app

# Clone the OpenManus repository
RUN git clone https://github.com/mannaandpoem/OpenManus.git /app

# Create and activate a virtual environment (recommended practice)
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip install --upgrade pip

# Install requirements if requirements.txt exists
RUN if [ -f "requirements.txt" ]; then \
        pip install -r requirements.txt; \
    else \
        # Install common AI dependencies as a fallback
        pip install torch torchvision torchaudio transformers \
        accelerate bitsandbytes sentencepiece protobuf einops \
        numpy scipy pandas matplotlib scikit-learn \
        Flask requests tqdm; \
    fi

# Install the package in development mode if setup.py exists
RUN if [ -f "setup.py" ]; then \
        pip install -e .; \
    fi

# Set up potential entry points
EXPOSE 7860  # Common port for Gradio apps
EXPOSE 8000  # Common port for FastAPI/Flask apps

# Command to run when the container starts
# Uncomment and modify as needed based on the actual project structure
# CMD ["python", "app.py"]
# or 
# CMD ["python", "-m", "openmanus.serve"]
# or for a gradio app
# CMD ["python", "gradio_app.py"]

# Default command - you'll need to customize this based on the project structure
CMD ["bash"]
