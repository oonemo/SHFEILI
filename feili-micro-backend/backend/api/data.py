import flask
from flask import request

import backend
from backend import util


@backend.app.route('/api/reports/<timestamp>/', methods=["GET", "POST"])
def get_report_data(timestamp):
    # This function is used to provide app with test report data
    # context contains:
    #   totalTested (Int): total # tested
    #   totalScheduled (Int): total # scheduled
    #   machineStatus (Dict): {machineNo: (Int) : {model: (String), numError: (Int),
    #                           status: (String)}}

    if "username" not in flask.session:
        util.aborting("403", "Forbidden")

    context = {}
    red = util.get_redis()
    if request.method == 'GET':
        report_name = 'report ' + timestamp
        machine_name = 'machineStatus ' + timestamp
        if red.exists(report_name):
            context = red.hgetall(report_name)
            machineStatus = red.hgetall(machine_name)
            context['machineStatus'] = machineStatus
    return flask.jsonify(**context)


@backend.app.route('/api/reports/', methods=["GET"])
def get_report_summary():
    # This function is used to provide app with all the test report name
    # context contains:
    #   reportsList (List): {(machineName: (String))}

    if "username" not in flask.session:
        util.aborting("403", "Forbidden")

    context = {}
    red = util.get_redis()
    if red.exists('reportsList'):
        reportsList = red.lrange('reportsList',0,-1)
        context['reportsList'] = reportsList
        print('testing', context)
    else:
        context['reportsList'] = []
    return flask.jsonify(**context)


@backend.app.route('/api/system_status/', methods=["GET", "POST"])
def get_status():
    # This function is used to send the machine status for testbed
    # context contains:
    #   working (Bool)
    #   machinesStatus (Dict): {machineNo: (Int) : {model: (String), numHit: (Int), status: (String)}}
    #   totalTested (Int): total # tested
    #   totalScheduled (Int): total # scheduled

    if "username" not in flask.session:
        util.aborting("403", "Forbidden")

    context = {}
    red = util.get_redis()
    if request.method == 'GET':
        if red.get('working') == 'true':
                totalTested = red.get('totalTested')
                totalScheduled = red.get('totalScheduled')
                machineStatus = red.hgetall('machineStatus')
                context['working'] = True
                context['totalTested'] = totalTested
                context['totalScheduled'] = totalScheduled
                context['machineStatus'] = machineStatus
        else:
                context['working'] = 'False'
    return flask.jsonify(**context)

@backend.app.route('/api/system_status_brief/', methods=["GET"])
def get_status_brief():
    if "username" not in flask.session:
        util.aborting("403", "Forbidden")

    context = {}
    red = util.get_redis()
    if red.get('working') == "true":
        context['working'] = True
        context['totalScheduled'] = red.get('totalScheduled')
        context['totalTested'] = red.get('totalTested')
    else:
        context['working'] = False
    return flask.jsonify(**context)


@backend.app.route('/api/stop_testing/', methods=["POST"])
def stop_testing():
    if "username" not in flask.session:
        util.aborting("403", "Forbidden")

    context = {}
    red = util.get_redis()

    if red.get('working') == 'true' and 'power_user' in flask.session:
        red.set('working', 'false')
        context['stop'] = True
    else:
        context['stop'] = False
    return flask.jsonify(**context)





