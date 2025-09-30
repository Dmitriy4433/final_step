from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def index():
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    return f"""
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Backend v5.4</title>
  <style>
    body {{
      background-color: #7C3AED;   /* ФІОЛЕТОВИЙ */
      color: #111111;              /* контрастний текст */
      font-family: Arial, sans-serif;
      text-align: center;
      padding-top: 80px;
    }}
    .ip {{
      font-size: 64px;             /* великий IP */
      font-weight: 800;
      letter-spacing: 2px;
      margin-bottom: 12px;
    }}
    .label {{
      color: #94a3b8;              /* приглушений сірий */
      margin-bottom: 24px;
    }}
    .host {{
      font-size: 24px;            /* середній розмір для hostname */
      font-weight: 600;
      color: #cbd5e1;
      margin-top: 6px;
    }}
    .host strong {{
      color: #60a5fa;              /* блакитний для акценту */
    }}
  </style>
</head>
<body>
  <div class="ip">{ip}</div>
  <div class="label">your public IP</div>
  <div class="host">version: <b>v5.4</b> • hostname: <strong>{hostname}</strong></div>
</body>
</html>
"""
