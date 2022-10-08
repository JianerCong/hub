const waitTime = 20000;
const waitInterval = 500;
let currentTime = 0;
const spaces = '                         ';
const lines = "\n\n\n\n\n";
const secs = 20000/ 1000;

const bar = (p=0) =>{
    // print a [========            ]
    const l = 20;
    process.stdout.write(spaces + '[');
    let k;
    k = Math.floor(20*p/100);
    let i;
    for (i = 0; i < k; i++){
        process.stdout.write('-');
    }
    for (i = k; i < l; i++){
        process.stdout.write(' ');
    }
    process.stdout.write(']');
};


const incTime = () => {
    currentTime += waitInterval;
    const p = Math.floor((currentTime / waitTime) * 100);
    process.stdout.clearLine();
    process.stdout.cursorTo(0);
    bar(p);
    // process.stdout.write(`waiting ... ${p}%`);
};

console.log(`After ${secs} seconds, magic will happen.`);

const timerFinished = () => {
    clearInterval(interval);
    process.stdout.clearLine();
    process.stdout.cursorTo(0);
    process.stdout.write(lines);
    console.log(`❄ You're ${secs} seconds older now. ❄`);
};

process.stdout.write(lines);
const interval = setInterval(incTime, waitInterval);
setTimeout(timerFinished, waitTime);

