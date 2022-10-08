import psycopg2
import pytest

def test_commit():
    conn = psycopg2.connect(user='me1',password='516826',
                            dbname='mydb',host='10.37.91.254')
    cur  = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS temp;")
    cur.execute("CREATE TABLE temp (x integer);")
    for i in range(3):
        cur.execute("INSERT INTO temp (x) VALUES (%s);",(i,))
    conn.commit()
    cur.close()
    conn.close()

    # open connection again
    conn = psycopg2.connect(user='me1',password='516826',
                            dbname='mydb',host='10.37.91.254')
    cur  = conn.cursor()
    cur.execute("SELECT * FROM temp;")
    out = cur.fetchall()
    assert out == [(i,) for i in range(3)]
    cur.close()
    conn.close()
