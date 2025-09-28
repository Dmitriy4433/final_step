# from flask import Flask, jsonify
# import os, socket

# app = Flask(__name__)

# @app.get("/")
# def root():
#     pod_ip = os.getenv("POD_IP")
#     if not pod_ip:
#         try:
#             pod_ip = socket.gethostbyname(socket.gethostname())
#         except Exception:
#             pod_ip = "unknown"
#     return jsonify({"ok": True, "pod_ip": pod_ip, "hostname": socket.gethostname()}), 200

# @app.get("/healthz")
# def healthz():
#     return "ok", 200

# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))


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
  <title>Backend</title>
  <style>
    body {{
      background-color: #0f172a;   /* темний фон */
      color: #e5e7eb;              /* світлий текст */
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
      font-size: 24px;             /* <-- збільшив тут */
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
  <div class="host">hostname: <strong>{hostname}</strong></div>
</body>
</html>
"""
