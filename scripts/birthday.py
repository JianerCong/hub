import datetime


def parse_string_to_date(db):
    for n in db:
        db[n] = datetime.date.fromisoformat(db[n])
    return db


def write_day_message(db):
    today =  datetime.date.today()
    print("Today is {0}".format(today))
    filename = 'birthday.txt'
    f = open(filename,mode='w')
    for name in db:
        day = db[name]
        # print("{0}'s birthday is {1}".format(name, day))
        if day.month == today.month and day.day == today.day:
            a = today.year - day.year
            msg ='Today is {0}\'s {1}th birthday\n'.format(name, a)
            print(msg)
            f.write(msg + '\n')
    f.close()

db = {
    "aa" : '2000-02-11',
    "bb" : '2000-03-15',
    "ll" : '2000-12-26',
    "xy" : '2000-11-26'
}
db = parse_string_to_date(db)
write_day_message(db)
