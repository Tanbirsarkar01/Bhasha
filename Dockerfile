FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Install pip and CPU-only PyTorch first to avoid pulling CUDA
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/cpu

# Install remaining dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Hugging Face cache and tokenizer envs
ENV HF_HOME=/root/.cache/huggingface \
    TRANSFORMERS_CACHE=/root/.cache/huggingface/hub \
    TOKENIZERS_PARALLELISM=false

# Pre-download the English→Hindi Marian model into the image
RUN python -c "from transformers import MarianMTModel, MarianTokenizer; m='Helsinki-NLP/opus-mt-en-hi'; MarianTokenizer.from_pretrained(m); MarianMTModel.from_pretrained(m)"

# Copy the app
COPY sequence_transduction.py .

# Run the translator
CMD ["python", "sequence_transduction.py"]
