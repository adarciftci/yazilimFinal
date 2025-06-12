#!/bin/bash
set -e
echo "---- Flask Başlatılıyor ----"
service ssh start
python app.py
