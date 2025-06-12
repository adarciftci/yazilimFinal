FROM python:3.11-slim

# Ortam değişkenleri
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Gerekli sistem paketleri
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SSH dizini oluştur
RUN mkdir /var/run/sshd

# Çalışma dizini
WORKDIR /app

# Gereksinimleri yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Tüm dosyaları kopyala
COPY . .

# start.sh'yi çalıştırılabilir yap
RUN chmod +x /app/start.sh

# Portları aç
EXPOSE 5000 2222

# Uygulama başlatma komutu
CMD ["/bin/bash", "/app/start.sh"]
