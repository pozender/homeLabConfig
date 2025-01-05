FROM python:3.11-slim

WORKDIR /app
RUN pip install --upgrade pip
RUN pip install --no-cache qbittorrent-api

COPY autoremovetracker.py .

CMD ["python", "autoremovetracker.py"]
