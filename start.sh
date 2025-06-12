#!/bin/bash
set -e

echo ">>> starting sshd"
/usr/sbin/sshd -p 2222 &

echo ">>> running python app"
python3 app.py
