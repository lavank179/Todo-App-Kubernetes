FROM python:3.12.4-alpine AS builder
WORKDIR /app

# needed for Pydantic/uPydantic
RUN apk add --no-cache gcc musl-dev libffi-dev

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12.4-alpine AS final
WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

EXPOSE 8881
CMD ["python", "main.py"]
