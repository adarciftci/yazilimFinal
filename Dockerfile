FROM python:3.11-slim

# Ortam değişkenleri
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Gerekli sistem paketleri (SSH vs.)
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SSH servisi için gerekli dizin
RUN mkdir /var/run/sshd

# Uygulama klasörü
WORKDIR /app

# Bağımlılıkları yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Tüm kaynak kodunu kopyala
COPY . .

# start.sh dosyasını çalıştırılabilir yap
RUN chmod +x start.sh

# Portları aç
EXPOSE 5000 2222

# Doğru şekilde tam path ile çalıştır

CMD ["/bin/bash", "/app/start.sh"]
