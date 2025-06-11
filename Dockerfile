FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN pip install transformers torch

COPY summarize.py .
COPY tf-apply-log.txt .

CMD ["python", "summarize.py"]
