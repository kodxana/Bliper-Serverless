FROM runpod/pytorch:3.10-2.0.0-117

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# install python packages
RUN pip install --no-cache-dir runpod salesforce-lavis

# Set the HF_HOME environment variable
ENV HF_HOME=/app/huggingface_cache

# Create the necessary directories for the model
RUN mkdir -p ${HF_HOME}/hub/checkpoints

# Copy the serverless implementation file into the container
COPY handler.py /app/handler.py

# Copy the model files to the container
COPY models/blip_coco_caption_base.pth ${HF_HOME}/hub/checkpoints/blip_coco_caption_base.pth


# Set the entry point
CMD ["python", "/app/handler.py"]
