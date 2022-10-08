from psycopg2 import ProgrammingError
import psycopg2
import pytest

class TestConn():
    def test_connection_fail(self):
        with pytest.raises(ProgrammingError, match='invalid dsn'):
            conn = psycopg2.connect('blah blah')

    def test_connection_ok(self):
        conn = psycopg2.connect(user='me1',password='516826',
                                dbname='mydb',host='10.37.91.254')
        assert not conn.closed
        conn.close()

@pytest.fixture(scope="session")
def conn():
    c = psycopg2.connect(user='me1',password='516826',
                         dbname='mydb',host='10.37.91.254')
    yield c
    c.close()

def test_cur(conn):
    cur = conn.cursor()
    assert not cur.closed
    cur.close()

