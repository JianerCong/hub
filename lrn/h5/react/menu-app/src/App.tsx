import React, { useState } from 'react'

/* interface menuItem {
 *     name: string;
 *     price: number;
 *     count?: number;
 * } */

function MenuItem(props) {
    return (
        <div>
            {props.name} | {props.price} | {props.count} |
            <button onClick={props.add}>+</button>
        | <button onClick={props.minus}>-</button>
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


function Menu(props) {
    const m = new Map(
        [
            ['egg', new menuItem(1.1)],
            ['apple', new menuItem(2.2)],
            ['wheat', new menuItem(3.3)],
            ['tomato', new menuItem(4.4)],
        ]
    );

    const [menu, setMenu] = useState(m);

    const items = [];
    menu.forEach(
        (item , name) => items.push(<MenuItem key={name} name={name}
                                   price={item.price} count={item.count}
                                   add={() => {
                                       console.log(`Adding ${name}`);
                                       // clone the menu
                                       const menu2 = Object.assign(m);

                                           // Add to the item
                                           let i = menu2.get(name);
                                           i.add();
                                           menu2.set(name,i);

                                           // Update the menu
                                           setMenu(menu2);
                                   }}

            minus={() => {
                console.log(`Minusing ${name}`);

                //    // clone the menu
                //    const menu2 = Object.assign(m);

                //    // Minus to the item
                //    let i = menu2.get(name);
                //    i.minus();
                                    //    menu2.set(name,i);

                                    //    // Update the menu
                                    //    setMenu(menu2);

                                   }}/>)
    );

    return (
        <div>
            {items}
        </div>
    );
}

function App() {
    const [count, setCount] = useState(0)

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
