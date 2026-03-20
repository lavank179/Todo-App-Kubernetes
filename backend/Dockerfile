
FROM python:3.12.4-slim AS builder

# Set environment variables to prevent Python from writing .pyc files and unbuffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*


FROM python:3.12.4-slim AS final
WORKDIR /usr/src/app

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY . .
EXPOSE 8881
CMD ["python3", "main.py"]