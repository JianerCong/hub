import './style.css'
import {gsap} from 'gsap'

console.log(`script loaded`)

console.log(`script is loaded.`)
let b = document.querySelector('body') as HTMLBodyElement;

// b.addEventListener('click', () => console.log('Body clicked'))

b.addEventListener('mousedown',
                   (e) => console.log(`mouse down : pageX-Y: ${e.pageX},${e.pageY}, screenX-Y ${e.screenX},${e.screenY}`))

// Move --------------------------------------------------
// gsap.to(".green", {
//     x: 200,
//     duration: 3,
//     repeat: 5,
//     yoyo: true,
//  })


// // repeat --------------------------------------------------
// gsap.to(".green", {
//     rotation: 360,
//     duration: 1,
//     repeat: 1,
//     repeatDelay: 1,
// });

// gsap.to(".yellow", {
//     rotation: 360,
//     duration: 1,
//     delay: 1 // delay the start of this animation
// });

// ease --------------------------------------------------
// gsap.to(".yellow", { duration: 2.5,
//                  ease: "power1.out",
//                      y: -200,
//                      repeat: 2,
//                      yoyo: true,
//                });

// 进场动画 --------------------------------------------------
// gsap.from(".box", {
//     duration: 2,
//     scale: 0.5,
//     opacity: 0,
//     delay: 0.5,
//     stagger: 0.2,               // delay between animations
//     ease: "elastic",
//     force3D: true
// });

// grid + stagger  --------------------------------------------------
// gsap.to(".grid .box", 1, {
//     scale: 0.1,
//     y: 60,
//     yoyo: true,
//     repeat: -1,
//     ease: "power1.inOut",
//     delay: 1,
//     stagger: {
//         amount: 1.5,
//         grid: "auto",
//         from: "center"
//     }
// });
