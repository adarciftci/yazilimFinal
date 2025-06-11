FROM python:3.11-slim

# SSH için kurulum
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Python bağımlılıklarını yükle
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kodları kopyala
COPY . .

# SSH user ekle
RUN useradd -rm -d /home/flaskuser -s /bin/bash -g root -G sudo -u 1000 flaskuser && \
    echo 'flaskuser:flaskpassword' | chpasswd

# SSH portu ve Flask portu aç
EXPOSE 22 5000

# Başlatma scripti
CMD ["./start.sh"]
