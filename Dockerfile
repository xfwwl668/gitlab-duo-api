FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    GITLAB_PROXY_HOST=0.0.0.0 \
    GITLAB_PROXY_PORT=7860 \
    DATA_DIR=/data \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r /app/requirements.txt \
    && python -m playwright install --with-deps chromium

RUN useradd -m -u 1000 user \
    && mkdir -p /data /app/data \
    && chmod 777 /data /app/data /ms-playwright

COPY --chown=user . /app

USER user

EXPOSE 7860

CMD ["python", "server.py"]
