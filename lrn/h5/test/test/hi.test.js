import { assert, expect, test } from 'vitest'

test('test 1', ()=>{
    expect('abc').toContain('a')
    expect(Math.sqrt(4)).toBe(2)
})

test('JSON', () => {
    const input = {
        foo: 'hello',
        bar: 'world',
    }

    const output = JSON.stringify(input)

    expect(output).eq('{"foo":"hello","bar":"world"}')
    assert.deepEqual(JSON.parse(output), input, 'matches original')
})

