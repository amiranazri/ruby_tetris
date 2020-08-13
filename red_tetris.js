const canvas = document.getElementById('red_tetris');
const context = canvas.getContext('2d');

context.scale(20, 20)
context.fillstyle = 'black';
context.fillRect(0, 0, canvas.width, canvas.height);    

const matrix = [
    [0, 0, 0],
    [1, 1, 1],
    [0, 1, 0],
]; 

// function draw() {
//     drawTetromino(player.matrix, player.pos);
// }

function drawTetromino(matrix, offset) {
    matrix.forEach((row, y) => {
        row.forEach((value, x) => {
            if (value !== 0) {
                context.fillStyle = 'blue';
                context.fillRect(x + offset.x, y + offset.y, 1, 1);
            }
        });
    });
}

// let dropCounter = 0;
// let dropInterval = 1000; //miliseconds == 1sec
// let previousTime = 0;

// function update(time = 0) {
//     const deltaTime = time - previousTime;
//     previousTime = time; 
//     // console.log(time);
//     dropCounter += deltaTime;
//     if (dropCounter > dropInterval) {
//         player.pos.y++;
//         dropCounter = 0;
//     }
//     requestAnimationFrame(update);
// } 

// const player = {
//     pos: {x: 5, y: 5},
//     matrix: matrix,
// }

// update();

drawTetromino(matrix, {x:5, y: 5})