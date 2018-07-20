from flask import session, request
from backend import util
import flask
import backend
from backend.util import check_password, create_password


@backend.app.route('/api/create_user/', methods=["POST", "GET"])
def create_user():
    context = {}
    if 'username' not in session:
        util.aborting("403", "Forbidden")

    if request.method == 'POST':
        password = request.form['password']
        username = request.form['username']
        new_password = request.form['create_password']
        new_username = request.form['new_username']
        is_power = check_password(password, username)[1]
        power = request.form['user_type'] == 'power'
        if is_power:
            result = create_password(new_password, new_username, power)
            if result:
                context['succeeded'] = False
                context['reason'] = 'Error: user already exists!'
            else:
                context['succeeded'] = True
        else:
            context['succeeded'] = False
            context['reason'] = 'Error: No admin rights!'

    return flask.jsonify(**context)


@backend.app.route('/api/login/', methods=["POST", "GET"])
def login():
    if 'username' in flask.session:
        util.aborting("403", "Forbidden")

    context = {}
    if request.method == 'POST':
        if 'username' in session:
            util.aborting("403", "Forbidden")
        username = request.form['username']
        password = request.form['password']

        is_user, is_power = check_password(password, username)
        if is_user:
            session['username'] = username
            context['is_user'] = True
            if is_power:
                session['power_user'] = True
        else:
            context['is_user'] = False

    return flask.jsonify(**context)


