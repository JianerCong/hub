import {menuItem} from '../src/App'

describe('menuItem', () => {
    test('initial state', () => {
        let p = 1.1;
        let i = new menuItem(p);

        expect(i.price).toBe(p);
        expect(i.count).toBe(0);
    });


    test('add items', () => {
        let p = 1.1;
        let i = new menuItem(p);

        i.add();
        i.add();
        expect(i.price).toBe(p);
        expect(i.count).toBe(2);
        expect(i.sum).toBe(2 * p);
    });

    test('minus', () => {
        let p = 1.1;
        let i = new menuItem(p);

        i.add();
        i.add();
        i.minus();
        expect(i.price).toBe(p);
        expect(i.count).toBe(1);
        expect(i.sum).toBe(p);
    });


    test('minus to zero', () => {
        let p = 1.1;
        let i = new menuItem(p);

        i.add();
        i.minus();
        i.minus();
        expect(i.price).toBe(p);
        expect(i.count).toBe(0);
        expect(i.sum).toBe(0);
    });
})
