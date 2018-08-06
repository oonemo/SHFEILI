import redis
import threading
import arrow
import random
import backend
import time

import sys
import array
import serial
from backend import util


def working_and_generate(ss):
    util.create_password('password', 'shfeili', power=True)
    red = util.get_redis()
    red.set('working', 'true')
    red.set('totalTested', 0)
    red.set('totalScheduled', 100)
    maxNumError = 10
    total_count = 0
    count = 0
    machineStatus = dict()
    for i in range(6):
        machineStatus[i] = dict()
        machineStatus[i]['model'] = 'NaN'
        machineStatus[i]['numError'] = 0
        machineStatus[i]['status'] = 'Working'
    run_test(ss)
    time.sleep(2)
    print("start to run test")
    while red.get('working') == 'true':
        #TODO: PLC PART
        print("in loop")
        total_count = getCycle(ss)  # needed to be fixed later
        print("cycle:",total_count)
        red.set('totalTested', total_count)
        time.sleep(1)
        for i in range(6):
            machineStatus[i]['numError'] = getFailure(ss, i+1)
            print(i, "failure: ",machineStatus[i]['numError'])
            if (machineStatus[i]['numError'] > maxNumError):
                machineStatus[i]['status'] = 'Error'
            else:
                machineStatus[i]['status'] = 'working'
        red.hmset('machineStatus', machineStatus)
    stop_test(ss)
    time.sleep(2)
    red.set('working', 'false')
    report = dict()
    report['totalTested'] = red.get('totalTested')
    report['totalScheduled'] = 100
    timeStamp = arrow.now().format('YYYY-MM-DD HH:mm:ss')
    red.rpush('reportsList', 'report ' + timeStamp)
    red.hmset('report ' + timeStamp, report) # could be trimmed
    red.hmset('machineStatus ' + timeStamp, machineStatus)
    red.delete('totalTested', 'totalScheduled', 'machineStatus')

def run_test(ser):
    ser.reset_input_buffer()
    ser.reset_output_buffer()
    ser.write(b'\x01\x05\x20\x01\x00\x00\x97\xca')
    print("run test;")
    print("in bytes; ",ser.in_waiting, ", out bytes; ",ser.out_waiting)

def stop_test(ser):
    ser.reset_input_buffer()
    ser.reset_output_buffer()
    ser.write(b'\x01\x05\x20\x01\xff\x00\xd6\x3a')
    print("stop test;")
    print("in bytes; ",ser.in_waiting, ", out bytes; ",ser.out_waiting)

def stop_alarm(ser):
    ser.reset_input_buffer()
    ser.reset_output_buffer()
    ser.write(b'\x01\x05\x20\x00\x00\x00\xc6\x0a')
    print("stop alarm;")
    print("in bytes; ",ser.in_waiting, ", out bytes; ",ser.out_waiting)

def alarm(ser):
    ser.reset_input_buffer()
    ser.reset_output_buffer()
    ser.write(b'\x01\x05\x20\x00\xff\x00\x87\xfa')
    print("alarm;")
    print("in bytes; ",ser.in_waiting, ", out bytes; ",ser.out_waiting)

def getCycle(ser):
    ser.reset_input_buffer()
    ser.reset_output_buffer()
    ser.write(b'\x01\x03\x00\x00\x00\x02\xc4\x0b')
    print("get cycle;")
    print("in bytes; ",ser.in_waiting, ", out bytes; ",ser.out_waiting)
    temp = ser.read(17)
    data = temp[13],temp[14],temp[11],temp[12]
    cycle = int.from_bytes(data,byteorder='big')
    return cycle

def getFailure(ser, switch):
    ser.reset_input_buffer()
    ser.reset_output_buffer()
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

def serial_init():
    ser = serial.Serial('/dev/tty.usbserial-A9080UAJ')  # open serial port
    ser.baudrate = 115200
    return ser

def serial_stop(ser):
    ser.close()


def main():
    # Initialize database
    red = redis.StrictRedis(host='127.0.0.1', charset="utf-8", decode_responses=True)
    print("heasdk")
    red.delete('totalTested', 'totalScheduled', 'machineStatus')
    red.set('working', 'false')
    print("heihei")

    global ss
    ss = serial.Serial('/dev/tty.usbserial-A9080UAJ')
    ss.baudrate = 115200
    t1 = threading.Thread(target=working_and_generate, args=[ss])
    print("haha")
    t1.run()
    pass

if __name__=="__main__":
    main()
