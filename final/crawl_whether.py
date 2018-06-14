import sys
import requests
from bs4 import BeautifulSoup
import datetime

file_name = 'whether.csv'
if __name__ == '__main__':
    url = 'http://e-service.cwb.gov.tw/HistoryDataQuery/DayDataController.do?command=viewMain&station=C0A9G0&stname=%25E5%258D%2597%25E6%25B8%25AF&datepicker='
    today = datetime.date.today()
    d = datetime.date(2016, 1, 1)
    fp = open(file_name, 'w')
    while d < today:
        if d.weekday() == 5:  #saturday
            response = requests.get((url+str(d)))
            #print(url+str(d))
            soup = BeautifulSoup(response.text, 'html.parser')
            whether = soup.select('div')[1]
            record = whether.select('tr')[9].select('td')    # 8 am
            s = ''
            s += str(d)+','
            s += (record[0].string + ',')
            s += (record[1].string + ',')
            s += (record[3].string + ',')
            s += (record[5].string + ',')
            s += (record[6].string + ',')
            s += (record[7].string + ',')
            s += (record[10].string )
            s += '\n'
            fp.write(s)
        d = d + datetime.timedelta(days=1)
    fp.close()
