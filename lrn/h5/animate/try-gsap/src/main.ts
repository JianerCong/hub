import './style.css'
import {gsap} from 'gsap'

console.log(`script loaded`)

console.log(`script is loaded.`)
let b = document.querySelector('body') as HTMLBodyElement;

// b.addEventListener('click', () => console.log('Body clicked'))

b.addEventListener('mousedown',
                   (e) => console.log(`mouse down : pageX-Y: ${e.pageX},${e.pageY}, screenX-Y ${e.screenX},${e.screenY}`))

// timeline --------------------------------------------------
// create a timeline

let tw = gsap.to(".green",{x: "100vw", duration: 5, rotation: 360,
                           onComplete: () => console.log("the tween is complete")
                          });


document.querySelector('#play')?.addEventListener('click',() => {
    console.log(`playing`);
    tw.play();
});


document.querySelector('#pause')?.addEventListener('click',() => {
    console.log(`pauseing`);
    tw.pause();
});


document.querySelector('#resume')?.addEventListener('click',() => {
    console.log(`resumeing`);
    tw.resume();
});

document.querySelector('#reverse')?.addEventListener('click',() => {
    console.log(`reverseing`);
    tw.reverse();
});


document.querySelector('#restart')?.addEventListener('click',() => {
    console.log(`restarting`);
    tw.restart();
});
