from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return {
        "message": "Production Swarm CI/CD Pipeline Updated",
        "hostname": socket.gethostname(),
        "version": "2.0"
    }

app.run(host="0.0.0.0", port=5000)
