from flask import Flask
import socket
import os

app = Flask(__name__)

@app.route("/")
def index():
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    version = os.getenv('APP_VERSION', 'unknown')  # Читаємо версію з env
    
    return f"""
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Backend {version}</title>
  <style>
    body {{
      background-color: #0A2540;
      color: #FFFFFF;
      font-family: Arial, sans-serif;
      text-align: center;
      padding-top: 80px;
    }}
    .ip {{
      color: #FFD700;
      font-size: 64px;
      font-weight: 800;
      letter-spacing: 2px;
      margin-bottom: 12px;
    }}
    .label {{
      color: #94a3b8;
      margin-bottom: 24px;
    }}
    .host {{
      font-size: 24px;
      font-weight: 600;
      color: #FFFFFF;
      margin-top: 6px;
    }}
    .host strong {{
      color: #FFFFFF;
    }}
  </style>
</head>
<body>
  <div class="ip">{ip}</div>
  <div class="label">your public IP</div>
  <div class="host">version: <b>{version}</b> • hostname: <strong>{hostname}</strong></div>
</body>
</html>
"""