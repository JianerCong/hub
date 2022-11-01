import { useState } from 'react'

interface menuItem {
    name: string;
    price: number;
    count?: number;
}


function Menu(props) {
    const menu : menuItem[] = [
        {name: 'egg', price: 1.1},
        {name: 'apple', price: 2.2},
        {name: 'wheat', price: 3.3},
        {name: 'tomato', price: 4.4},
    ];

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
        <Menu/>
    </div>
  )
}

export default App
