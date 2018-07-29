import redis
import threading
import arrow
import random
import backend
import time
from backend import util


def working_and_generate():
    util.create_password('password', 'shfeili', power=True)
    red = util.get_redis()
    red.set('working', 'true')
    red.set('totalTested', 0)
    red.set('totalScheduled', 1000)
    total_count = 0
    count = 0
    machineStatus = dict()
    for i in range(10):
        machineStatus[i] = dict()
        machineStatus[i]['model'] = 'SJTUJI2'
        machineStatus[i]['numError'] = 0
        machineStatus[i]['status'] = 'Working'
    while count < 1000 and red.get('working') == 'true':
        #TODO: PLC PART
        total_count += 1  # needed to be fixed later
        red.set('totalTested', total_count)
        count += 1
        time.sleep(0.1)
        for i in range(10):
            if random.randint(0, 200) == 1:
                machineStatus[i]['numError'] += random.randint(0, 1)
            if machineStatus[i]['numError'] != 0:
                machineStatus[i]['status'] = 'Error'
            else:
                machineStatus[i]['status'] = 'Working'
        red.hmset('machineStatus', machineStatus)
    red.set('working', 'false')
    red.delete('totalTested', 'totalScheduled', 'machineStatus')
    report = dict()
    report['totalTested'] = count
    report['totalScheduled'] = 1000
    timeStamp = arrow.now().format('YYYY-MM-DD HH:mm:ss')
    red.rpush('reportsList', 'report ' + timeStamp)
    red.hmset('report ' + timeStamp, report) # could be trimmed
    red.hmset('machineStatus ' + timeStamp, machineStatus)


t1 = threading.Thread(target=working_and_generate())


def main():
    # Initialize database
    red = redis.StrictRedis(host='127.0.0.1', charset="utf-8", decode_responses=True)
    red.delete('totalTested', 'totalScheduled', 'machineStatus')
    red.set('working', 'false')
    t1.run()
    pass
