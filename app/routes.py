import socket
from flask import Blueprint

bp = Blueprint("main", __name__)

@bp.route("/")
def hello():
    host_name = socket.gethostname()
    return f"Hello from Dockerized Flask App! Running on {host_name}"
