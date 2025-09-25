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



from flask import Flask, request, jsonify, make_response
import socket
import os

app = Flask(__name__)

def client_ip():
    # IP клієнта (з урахуванням проксі/ingress)
    xff = request.headers.get("X-Forwarded-For")
    return xff.split(",")[0].strip() if xff else request.remote_addr

@app.route("/healthz")
def healthz():
    return ("", 200)

@app.route("/api")
def api():
    return jsonify({
        "hostname": socket.gethostname(),
        "ok": True,
        "client_ip": client_ip()
    }), 200

@app.route("/")
def index():
    # Якщо хочеш JSON на корені: /?format=json
    if request.args.get("format") == "json":
        return api()

    ip = client_ip()
    host = socket.gethostname()
    html = f"""
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title>your public IP</title>
      <style>
        body {{
          margin: 0; height: 100vh; display: grid; place-items: center;
          background: #0e1621; color: #dbe7ff; font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
        }}
        .wrap {{ text-align: center; }}
        .ip   {{ font-size: clamp(40px, 8vw, 72px); font-weight: 800; letter-spacing: .02em; }}
        .sub  {{ margin-top: 8px; opacity: .7; font-size: 14px; }}
        .host {{ margin-top: 16px; opacity: .5; font-size: 12px; }}
      </style>
    </head>
    <body>
      <div class="wrap">
        <div class="ip">{ip}</div>
        <div class="sub">your public IP</div>
        <div class="host">hostname: {host}</div>
      </div>
    </body>
    </html>
    """
    return make_response(html, 200)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
