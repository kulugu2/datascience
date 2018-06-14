import sys
import pycurl
import tarfile
import datetime
import csv
import shutil
f31 = 'traffic31.csv'
f32 = 'traffic32.csv'
f41 = 'traffic41.csv'
f42 = 'traffic42.csv'
f5 = 'traffic5.csv'
if __name__ == '__main__':
    ##     output file
    wf31 = open(f31, 'w')
    wf32 = open(f32, 'w')
    wf41 = open(f41, 'w')
    wf42 = open(f42, 'w')
    wf5 = open(f5, 'w')
    writer31 = csv.writer(wf31, lineterminator = '\n')
    writer32 = csv.writer(wf32, lineterminator = '\n')
    writer41 = csv.writer(wf41, lineterminator = '\n')
    writer42 = csv.writer(wf42, lineterminator = '\n')
    writer5 = csv.writer(wf5, lineterminator = '\n')
    
    endday = datetime.date(2018, 4, 30)
    ## download file
    d = datetime.date(2016, 1, 1)
    while d < endday:
        if d.weekday() != 5:
            d = d + datetime.timedelta(days=1)
            continue

        d_str = d.strftime('%Y%m%d')
        with open('M04.tar.gz','wb') as f:
            c = pycurl.Curl()
            c.setopt(c.URL, 'http://tisvcloud.freeway.gov.tw/history/TDCS/M04A/M04A_'+d_str+'.tar.gz')
            c.setopt(c.WRITEDATA, f)
            c.perform()
            c.close()            
        with open('M05.tar.gz','wb') as f:
            c = pycurl.Curl()
            c.setopt(c.URL, 'http://tisvcloud.freeway.gov.tw/history/TDCS/M05A/M05A_'+d_str+'.tar.gz')
            c.setopt(c.WRITEDATA, f)
            c.perform()
            c.close()
        '''
        with open('M03.tar.gz','wb') as f:
            c = pycurl.Curl()
            c.setopt(c.URL, 'http://tisvcloud.freeway.gov.tw/history/TDCS/M03A/M03A_'+d_str+'.tar.gz')
            c.setopt(c.WRITEDATA, f)
            c.perform()
            c.close()
        '''

        # read file
        #with tarfile.open('M03.tar.gz') as tf:
        #    tf.extractall()
        with tarfile.open('M04.tar.gz') as tf:
            tf.extractall()
        with tarfile.open('M05.tar.gz') as tf:
            tf.extractall()
        
        str31 = []
        str32 = []
        str41 = []
        str42 = []
        str5  = []

        with open(('M04A/'+d_str+'/08/TDCS_M04A_'+d_str+'_083000.csv'), 'r') as fp:
            lines = fp.readlines()
            for line in lines:
                l = line.strip().split(',')
                if l[1] == '05F0055S':
                    if l[3] == '31':
                        str31 = list(l)
                    if l[3] == '32':
                        str32 = list(l)
                    if l[3] == '41':
                        str41 = list(l)
                    if l[3] == '42':
                        str42 = list(l)
                    if l[3] == '5':
                        str5 = list(l)
        
        with open(('M05A/'+d_str+'/08/TDCS_M05A_'+d_str+'_083000.csv'), 'r') as fp:
            lines = fp.readlines()
            for line in lines:
                l = line.strip().split(',')
                if l[1] == '05F0055S':
                    if l[3] == '31':
                        str31.extend(l[4:6])
                    if l[3] == '32':
                        str32.extend(l[4:6])
                    if l[3] == '41':
                        str41.extend(l[4:6])
                    if l[3] == '42':
                        str42.extend(l[4:6])
                    if l[3] == '5':
                        str5.extend(l[4:6])

        writer31.writerow(str31)
        writer32.writerow(str32)
        writer41.writerow(str41)
        writer42.writerow(str42)
        writer5.writerow(str5)
        
        shutil.rmtree('M04A')
        shutil.rmtree('M05A')
        d = d + datetime.timedelta(days=1)

    wf31.close()
    wf32.close()
    wf41.close()
    wf42.close()
    wf5.close()

