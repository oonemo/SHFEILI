import redis
import threading
import arrow
import random
import backend
import time

import sys
import serial
import array
from backend import util


def working_and_generate():
    util.create_password('password', 'shfeili', power=True)
    red = util.get_redis()
    red.set('working', 'true')
    red.set('totalTested', 0)
    red.set('totalScheduled', 100)
    maxNumError = 10
    total_count = 0
    count = 0
    machineStatus = dict()
    ser = serial_init()
    for i in range(6):
        machineStatus[i] = dict()
        machineStatus[i]['model'] = 'NaN'
        machineStatus[i]['numError'] = 0
        machineStatus[i]['status'] = 'Working'
    while red.get('working') == 'true':
        #TODO: PLC PART
        total_count = getCycle(ser)  # needed to be fixed later
        red.set('totalTested', total_count)
        time.sleep(0.1)
        for i in range(6):
            machineStatus[i]['numError'] = getFailure(i+1, ser)
            if (machineStatus[i]['numError'] > maxNumError):
                machineStatus[i]['status'] = 'Error'
            else:
                machineStatus[i]['status'] = 'working'
        red.hmset('machineStatus', machineStatus)
    stop_test(ser)
    red.set('working', 'false')
    red.delete('totalTested', 'totalScheduled', 'machineStatus')
    report = dict()
    report['totalTested'] = red.get('totalTested')
    report['totalScheduled'] = 100
    timeStamp = arrow.now().format('YYYY-MM-DD HH:mm:ss')
    red.rpush('reportsList', 'report ' + timeStamp)
    red.hmset('report ' + timeStamp, report) # could be trimmed
    red.hmset('machineStatus ' + timeStamp, machineStatus)

def stop_test(ser):
    ser.write(b'\x01\x05\x20\x01\x00\x00\x97\xca')

def run_test(ser):
    ser.write(b'\x01\x05\x20\x01\xff\x00\xd6\x3a')

def stop_alarm(ser):
    ser.write(b'\x01\x05\x20\x00\x00\x00\xc6\x0a')

def alarm(ser):
    ser.write(b'\x01\x05\x20\x00\xff\x00\x87\xfa')

def getCycle(ser):
    ser.write(b'\x01\x03\x00\x00\x00\x02\xc4\x0b')
    temp = ser.read(17)
    data = temp[13],temp[14],temp[11],temp[12]
    cycle = int.from_bytes(data,byteorder='big')
    return cycle

def getFailure(switch, ser):
    if switch == 1:
        ser.write(b'\x01\x03\x00\x02\x00\x01\x25\xca')
        temp = ser.read(15)
        data = temp[11],temp[12]
        cycle = int.from_bytes(data,byteorder='big')
    elif switch == 2:
        ser.write(b'\x01\x03\x00\x03\x00\x01\x74\x0a')
        temp = ser.read(15)
        data = temp[11],temp[12]
        cycle = int.from_bytes(data,byteorder='big')
    elif switch == 3:
        ser.write(b'\x01\x03\x00\x04\x00\x01\xc5\xcb')
        temp = ser.read(15)
        data = temp[11],temp[12]
        cycle = int.from_bytes(data,byteorder='big')
    elif switch == 4:
        ser.write(b'\x01\x03\x00\x05\x00\x01\x94\x0b')
        temp = ser.read(15)
        data = temp[11],temp[12]
        cycle = int.from_bytes(data,byteorder='big')
    elif switch == 5:
        ser.write(b'\x01\x03\x00\x06\x00\x01\x64\x0b')
        temp = ser.read(15)
        data = temp[11],temp[12]
        cycle = int.from_bytes(data,byteorder='big')
    elif switch == 6:
        ser.write(b'\x01\x03\x00\x07\x00\x01\x35\xcb')
        temp = ser.read(15)
        data = temp[11],temp[12]
        cycle = int.from_bytes(data,byteorder='big')
    else:
        return 0

    return cycle

def serial_end(ser):
    ser.close()

def serial_init():
    ser = serial.Serial('/dev/ttyUSB0')
    ser.baudrate = 115200
    return ser



def main():
    # Initialize database
    red = redis.StrictRedis(host='127.0.0.1', charset="utf-8", decode_responses=True)
    red.delete('totalTested', 'totalScheduled', 'machineStatus')
    red.set('working', 'false')
    t1 = threading.Thread(target=working_and_generate())
    t1.run()
    pass
