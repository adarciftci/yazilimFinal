import os
import psycopg2
from flask import Flask
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

app = Flask(__name__)

# 🔐 Key Vault bilgileri
KEY_VAULT_NAME = "yazilimmidtermkv"  # kendi vault adın
KVUri = f"https://{KEY_VAULT_NAME}.vault.azure.net"

# 🎫 Kimlik doğrulama
credential = DefaultAzureCredential()
client = SecretClient(vault_url=KVUri, credential=credential)

# 🔑 Secretları çek
PGHOST = client.get_secret("PGHOST").value
PGPASSWORD = client.get_secret("PASSWORD").value
PGDATABASE = client.get_secret("PGDATABASE").value
PGPORT = client.get_secret("PGPORT").value
PGUSER = client.get_secret("userNew").value

# 🎯 Ana sayfa
@app.route("/")
def index():
    return "<h2>Flask app is running!</h2><p>Try <a href='/hello'>/hello</a></p>"

# 📦 Veritabanına bağlan
@app.route("/hello")
def hello():
    try:
        conn = psycopg2.connect(
            host=PGHOST,
            dbname=PGDATABASE,
            user=PGUSER,
            password=PGPASSWORD,
            port=PGPORT,
            sslmode="require"
        )
        cur = conn.cursor()
        cur.execute("SELECT * FROM ogrenciler;")
        rows = cur.fetchall()
        cur.close()
        conn.close()

        result = "<h3>Öğrenciler:</h3><ul>"
        for row in rows:
            result += f"<li>{row}</li>"
        result += "</ul>"
        return result

    except Exception as e:
        return f"<b>Veritabanı hatası:</b><br>{str(e)}"

# 🚀 Uygulama başlat
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)