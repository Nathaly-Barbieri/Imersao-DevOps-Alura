FROM python:3.13.5-alpine3.22 AS builder

WORKDIR /app

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.13.5-alpine3.22

WORKDIR /app

RUN addgroup -S app && adduser -S -G app app

COPY --from=builder /opt/venv /opt/venv

COPY . .

RUN chown -R app:app /app

USER app

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

