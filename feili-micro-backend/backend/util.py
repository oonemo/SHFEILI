"""BackEnd Utils"""
import redis
import socket
import json
import threading
import time
import flask
import backend
import uuid
import hashlib

buffer_size = 1024
ip = "localhost"

def get_redis():
    # connect database
    return redis.StrictRedis(host='127.0.0.1', charset="utf-8", decode_responses=True)

def send_message(IP, PORT, data):
    """Create a new socket and send message."""
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((IP, PORT))
    s.sendall(data.encode('utf-8'))
    s.close()

def recv_message(port_num):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((ip, port_num))
    s.listen(5)
    client_socket, address = s.accept()
    message = client_socket.recv(buffer_size).decode("utf-8")
    data = json.loads(message)
    client_socket.close()

def aborting(status_code, message):
    flask.abort(flask.make_response(flask.jsonify(
        message=message,
        status_code=status_code
    ), 403))  # if the user is not logged in, we should not provide api access

def create_password(password, username, power=False):
    red = get_redis()
    if red.hexists('users', username):
        backend.app.logger.debug("User exists.")
        return False
    algorithm = 'sha512'
    salt = uuid.uuid4().hex
    hash_obj = hashlib.new(algorithm)
    password_salted = salt + password
    hash_obj.update(password_salted.encode('utf-8'))
    password_hash = hash_obj.hexdigest()
    password_db_string = "$".join([algorithm, salt, password_hash])
    red.hset('users', username, password_db_string)
    if power:
        red.sadd('power_users', username)
    return True


def check_password(password, username):
    red = get_redis()

    if not red.hexists('users', username):
        backend.app.logger.debug("No such user")
        return False, False
    else:
        parts = red.hmget('users', username)[0].split("$")
        algorithm = parts[0]
        salt = parts[1]
        hashed = parts[2]
        hash_obj = hashlib.new(algorithm)
        password_salted = salt + password
        hash_obj.update(password_salted.encode('utf-8'))
        password_hash = hash_obj.hexdigest()
        # backend.app.logger.debug(password_hash)
        # backend.app.logger.debug(hashed)
        # backend.app.logger.debug(salt)
        if password_hash == hashed:
            #backend.app.logger.debug("Login OK")
            if red.sismember('power_users', username):
                return True, True
            else:
                return True, False
        else:
            backend.app.logger.debug("Password Not match")
            return False, False
