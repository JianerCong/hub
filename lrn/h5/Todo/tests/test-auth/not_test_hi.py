import pytest

@pytest.fixture()
def f():
    print('Before fixture')
    yield None
    print('After fixture')

def test_hi(f):
    print('In test')
    assert 1 == 1
