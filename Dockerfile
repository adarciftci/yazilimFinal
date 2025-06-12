FROM python:3.11-slim

# Ortam değişkenleri
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Gerekli sistem paketleri (isteğe bağlı: SSH varsa bırak)
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x start.sh

EXPOSE 5000 2222

CMD ["/bin/bash", "./start.sh"]
