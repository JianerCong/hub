const canvas = document.createElement('canvas')
// const L = 256
const L = 500
canvas.width = L
canvas.height = L

// get the context
var context = canvas.getContext("2d")
context.fillStyle = "#ffffaa"
context.fillRect(0, 0, L, L)    // fill the screen with yellow

document.body.appendChild(canvas)


// Text
context.fillStyle  = "#000000";
context.font = "20px Sans-Serif";
context.textBaseline = "top";
context.fillText  ("Hello World!", 195, 80);

//image
var i = new Image();
i.onload = function () {
  context.drawImage(i, 10, 11);
}
i.src = "error_no_bg.png";

//box
context.strokeStyle = "#000000";
context.strokeRect(5,  5, 490, 290);

