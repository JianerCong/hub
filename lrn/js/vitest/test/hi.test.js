import { assert, expect, test } from 'vitest';

test('Math.sqrt()', () => {
  expect(Math.sqrt(4)).toBe(2);
  expect(Math.sqrt(144)).toBe(12);
  expect(Math.sqrt(2)).toBe(Math.SQRT2);
});


test('test an unseen property', () => {
  let a = {x:1};
  Object.defineProperty(a, "_y", {
    value: 1,
    writable: true,
    enumerable: false,
    configurable: false
  });

  assert.deepEqual(a, {x:1});
  expect(a._y).toBe(1);
});
