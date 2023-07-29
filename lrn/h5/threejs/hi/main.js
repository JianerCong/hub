// const TWEEN = require('@tweenjs/tween.js');
import TWEEN from './tween.esm.js';

const box = document.createElement('div')
box.style.setProperty('background-color', '#008800')
box.style.setProperty('width', '100px')
box.style.setProperty('height', '100px')
document.body.appendChild(box)

// Setup the animation loop.
function animate(time) {
	requestAnimationFrame(animate)
	TWEEN.update(time)
  // console.log(time);
}
requestAnimationFrame(animate)

const coords = {x: 0, y: 0} // Start at (0, 0)
const tween = new TWEEN.Tween(coords) // Create a new tween that modifies 'coords'.
	    .to({x: 300, y: 200}, 1000) // Move to (300, 200) in 1 second.
	    .easing(TWEEN.Easing.Quadratic.Out) // Use an easing function to make the animation smooth.
	    .onUpdate(() => {
		    // Called after tween.js updates 'coords'.
		    // Move 'box' to the position described by 'coords' with a CSS translation.
		    box.style.setProperty('transform', `translate(${coords.x}px, ${coords.y}px)`);
        console.log(coords);
	    })
	    .start() // Start the tween immediately.
