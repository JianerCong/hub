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
            <button onClick={props.add}>+</button> | <button onClick={props.minus}>-</button>
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
    const menu = new Map(
        [
            ['egg', {price: 1.1}],
            ['apple', {price: 2.2}],
            ['wheat', {price: 3.3}],
            ['tomato', {price: 4.4}],
        ]
    );

    const items = menu.map(
        (item: menuItem) => <div key={item.name}>{item.name} | {item.price}</div>
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
        {/* <Menu/> */}
    <MenuItem name="egg" price={1.1} count={count}
              add={() => setCount(count + 1) }
              minus={() => setCount(count - 1) }
    />
    </div>
  )
}

export {menuItem}
export default App
