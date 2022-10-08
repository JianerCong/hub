import datetime
from datetime import date

# {{{ headers

def parse_string_to_date(db): raise Exception('parse_string_to_date')
def is_special_name(n): return n.startswith('ddl.')
def handle_special(n,db): raise Exception('handle special <name>')
def handle_birthday(n,db): raise Exception('handle birthday')

# def debugp(s): print(s)
def debugp(s): return

today =  date.today()

# }}}
# {{{ main

def main(db):
    print("dayrmd.py: Today is {0}".format(today))
    db = parse_string_to_date(db)
    f = open(out_filename, 'w', encoding='utf8')
    for n in db:
        debugp('Handling n = {0} in db'.format(n))
        if is_special_name(n):
            debugp('Handling special')
            msg = handle_special(n,db)
        else:
            debugp('Handling birthday')
            msg = handle_birthday(n,db)
        if msg != '':
            msg = '(ㆆ _ ㆆ) ' + msg + '\n'
            debugp(msg)
            f.write(msg)
    f.close()

    # }}}
# {{{ parse_string_to_date

def parse_string_to_date(db):
    debugp('real parse_string_to_date()')
    for n in db:
        db[n] = datetime.date.fromisoformat(db[n])
    return db

# }}}
# {{{ handle_special

def handle_special(n,db):
    if n.startswith('ddl.'):
        return handle_ddl(n,db)

    # {{{ handle_ddl

def get_ddl_duration(s): raise Exception('get_ddl_duration')
def handle_ddl(n,db):
    d = db[n]
    s = n[4:]
    debugp('d is {0}, s is {1}'.format(d,s))
    # i: allowed days
    i , s = get_ddl_duration(s)
    dif = (d - today).days
    debugp('after ddl handling: i is {0}, s is {1}, diff is {2}'.format(i,s,dif))
    if dif < i:
        ds = 'day'
        if dif > 1:
            ds += 's'
        return 'Deadline alert: {0}, {1} {2} left'.format(s,dif,ds)
    else:
        return ''

def start_with_timespec(s): raise Exception('start_with_timespec')
def try_parse_duration(s): raise Exception('try_parse_duration')
def get_ddl_duration(s):
    if start_with_timespec(s):
        return try_parse_duration(s)
    else:
        return (10 ,s)

    # }}}

def get_timespec_regex():
    import re
    # if starts with ddd. or dddw. or dddm.
    r = re.compile(r'^(\d+[wm]?)\.(.*)')
    return r

def start_with_timespec(s):
    r = get_timespec_regex()
    return r.search(s) != None

def parse_date_spec(sp): raise Exception('parse_date_spec')
def try_parse_duration(s):
    r = get_timespec_regex()
    o = r.search(s)
    sp , s = o.groups()         # structured binding
    day = parse_date_spec(sp)
    return (day , s)

def parse_date_spec(sp):
    if sp.endswith('w'):
        n = sp[:-1]
        d = int(n) * 7
    elif sp.endswith('m'):
        n = sp[:-1]
        d = int(n) * 30
    else:
        d = int(sp)
    return d

# }}}
# {{{ handle_birthday
def handle_birthday(n,db):
    day = db[n]
    this_year_birthday = date(today.year,day.month,day.day)
    days_to = (this_year_birthday - today).days
    debugp('day: {0}, this year birthday: {1}, days_to: {2}'.format(
          day, this_year_birthday, days_to))
    # if day.month == today.month and day.day == today.day:
    if days_to < 0:             # already had birthday this year
        return ''
    elif days_to == 0:
        a = today.year - day.year
        return 'Today is {0}\'s {1}th birthday'.format(n, a)
    elif days_to == 1:
        return '{0}\'s birthday is tomorrow'.format(n,days_to)
    elif days_to < 3:
        return '{0}\'s birthday comming in {1} days'.format(n,days_to)
    else:                       # too early
        return ''
# }}}
# {{{ read_db_from_csv()

def parse_this_line(l): raise Exception('parse_this_line')
def read_db_from_csv(filename):
    f = open(filename, 'r', encoding='utf8')
    db = dict();
    for line in f.readlines():
        n, d = parse_this_line(line)
        db[n] = d
    return db

def parse_this_line(l):
    ss = l.split(',',1)         # split into two pieces
    # trim and output
    return (ss[0].strip() , ss[1].strip())

# }}}

def write_message_file(sourcedir):
    filename = os.path.join(sourcedir,'log.txt')
    f = open(filename, 'w', encoding='utf8')
    f.write('Last run: {0}'.format(datetime.datetime.now()))
    f.close()

import os
# print('Current dir is {0}'.format(os.getcwd()))  # ⇒ the invoking dir
sourcedir = os.path.dirname(os.path.abspath(__file__))
filename = os.path.join(sourcedir, 'days.csv')
out_filename = os.path.join(sourcedir, 'msg.txt')

# write the message file
write_message_file(sourcedir)



debugp('Input file is {0}, Output file is {1}'.format(
    filename,
    out_filename
))  # ⇒ the invoking dir
db = read_db_from_csv(filename)

main(db)
