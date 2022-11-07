console.log(`script is loaded.`)
let b = document.querySelector('body')

// b.addEventListener('click', () => console.log('Body clicked'))

b.addEventListener('mousedown',(e) => console.log(`mouse down : pageX-Y: ${e.pageX},${e.pageY}, screenX-Y ${e.screenX},${e.screenY}`))