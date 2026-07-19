from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def home():
    hostname = socket.gethostname()

    return {
        "message": "Hello from Docker Swarm",
        "container": hostname
    }


app.run(host="0.0.0.0", port=5000)
