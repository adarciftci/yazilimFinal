#!/bin/bash
set -e

/usr/sbin/sshd -p 2222 &

python3 app.py
