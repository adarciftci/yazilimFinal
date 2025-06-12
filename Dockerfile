FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# 🛠️ start.sh dosyasına çalıştırma izni ver
RUN chmod +x start.sh

RUN useradd -rm -d /home/flaskuser -s /bin/bash -g root -G sudo -u 1000 flaskuser && \
    echo 'flaskuser:flaskpassword' | chpasswd

EXPOSE 5000 2222

CMD ["/bin/bash", "./start.sh"]