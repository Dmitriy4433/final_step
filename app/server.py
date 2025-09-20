from flask import Flask, jsonify
import os, socket

app = Flask(__name__)

@app.get("/")
def root():
    pod_ip = os.getenv("POD_IP")
    if not pod_ip:
        try:
            pod_ip = socket.gethostbyname(socket.gethostname())
        except Exception:
            pod_ip = "unknown"
    return jsonify({"ok": True, "pod_ip": pod_ip, "hostname": socket.gethostname()}), 200

@app.get("/healthz")
def healthz():
    return "ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
