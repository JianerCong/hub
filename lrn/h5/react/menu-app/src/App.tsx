import React, { useState } from 'react'

const formatData = Intl.NumberFormat("en", {
    style: "currency",
    currency: "USD",
    minimumFractionDigits: 0,
    maximumFractionDigits: 2
}).format

type MenuItemProps = {
    name: string,
    price: number,
    count: number,
    sum: number,
    add: () => void,
    minus: () => void
}

function MenuItem(props: MenuItemProps) {

    return (
        <div>
            {props.name} | {props.price} | {props.count} |
            <button onClick={props.add}>+</button>
        | <button onClick={props.minus}>-</button> | {formatData(props.sum)}
        </div>
    )
}

class menuItem {
    price = 0;
    count = 0;

    constructor(price: number) {
        this.price = price;
    }
    add() {
        this.count++;
    }
    minus() {
        if (this.count > 0) {
            this.count--;
        }
    }

    get sum() {
        return this.price * this.count;
    }
}


function Menu() {
    const m : Map<string,menuItem> = new Map(
        [
            ['egg', new menuItem(1.1)],
            ['apple', new menuItem(2.2)],
            ['wheat', new menuItem(3.3)],
            ['tomato', new menuItem(4.4)],
        ]
    );

    const [menu, setMenu] = useState(m);

    const items: JSX.Element[] = [];
    menu.forEach(
        (item , name) => items.push(
            <MenuItem key={name} name={name} price={item.price} count={item.count}
            sum={item.sum}
            add={() => {
                console.log(`Adding ${name}`);
                // clone the menu
                const menu2 = new Map([...menu]);
                // Add to the item
                const i = menu2.get(name) as menuItem;
                i.add();
                menu2.set(name,i);

                console.log(`menu2 has entries: \n${JSON.stringify([...menu2])}`);
                // Update the menu
                setMenu(menu2);
            }}
            minus={() => {
                console.log(`Minusing ${name}`);
                // clone the menu
                const menu2 = new Map([...menu]);
                // Add to the item
                const i = menu2.get(name) as menuItem;
                i.minus();
                menu2.set(name,i);

                console.log(`menu2 has entries: \n${JSON.stringify([...menu2])}`);
                // Update the menu
                setMenu(menu2);

            }}
            />)
    );

    const sum = [...menu.values()].map(item => item.sum).reduce((a,b) => a + b);

    return (
        <div>
            {items}
            <div>Total: {formatData(sum)}</div>
        </div>
    );
}

function App() {
  return (
    <div className="App">
        <Menu/>
        {/* <MenuItem name="egg" price={1.1} count={count}
            add={() => setCount(count + 1) }
            minus={() => setCount(count - 1) } /> */}
    </div>
  )
}

export {menuItem}
export default App
