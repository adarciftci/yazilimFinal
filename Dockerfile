# Base image
FROM python:3.11-slim

# Ortam değişkenleri
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Gerekli sistem paketleri (SSH için)
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SSH servisi için çalışma dizinleri
RUN mkdir /var/run/sshd

# Uygulama dizinine geç
WORKDIR /app

# Gereksinimleri kopyala ve yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kodları kopyala
COPY . .

# SSH kullanıcı oluştur
RUN useradd -rm -d /home/flaskuser -s /bin/bash -g root -G sudo -u 1000 flaskuser && \
    echo 'flaskuser:flaskpassword' | chpasswd

# Portları aç (Flask ve SSH için)
EXPOSE 5000 22

# Başlangıç betiği
CMD ["./start.sh"]
