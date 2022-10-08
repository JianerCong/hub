from psycopg2 import ProgrammingError
import psycopg2
import pytest

@pytest.fixture(scope="session")
def cur():
    """Create an open cursor to mydb"""
    conn = psycopg2.connect(user='me1',password='516826',
                         dbname='mydb',host='10.37.91.254')
    c = conn.cursor()
    yield c
    c.close()
    conn.close()

def test_create_df(cur):
    cur.execute(
        """
        CREATE TABLE df1 (id serial PRIMARY KEY,num integer,data varchar);
        """)
    cur.execute("INSERT INTO df1 (num, data) VALUES (%s, %s);",(100,"ab'cd"))
    cur.execute("SELECT * FROM df1;")
    assert cur.fetchall() == [(1,100,"ab'cd")]
    # change not committed, so no need to delete table?


def test_df_fetch_three(cur):
    l1 = range(1,1+3)           # [1,2,3]
    l2 = 'abc'
    vals = list(zip(l1,l2))
    cur.execute(
        """
        CREATE TABLE df1 (id serial PRIMARY KEY,num integer,data varchar);
        """)

    def insert_into_df1(cur,val):
        cur.execute("INSERT INTO df1 (num, data) VALUES (%s, %s);",val)
        return cur

    for val in vals:
        cur = insert_into_df1(cur,val)

    cur.execute("SELECT * FROM df1;")
    out = cur.fetchall()
    assert out == list(zip(l1,l1,l2))
