const canvas = document.getElementById('red_tetris');
const context = canvas.getContext('2d');

const matrix = [
    [0, 0, 0],
    [1, 1, 1],
    [0, 1, 0],
]; 

context.scale(20, 20)
    


function draw() {
    context.fillstyle = 'black';
    context.fillRect(0, 0, canvas.width, canvas.height);
    drawTetromino(player.matrix, player.position);
}

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

let dropCounter = 0;
let dropInterval = 1000; //miliseconds == 1sec
let previousTime = 0;

function update(time = 0) {
    const deltaTime = time - previousTime;
    previousTime = time; 
    // console.log(time);
    dropCounter += deltaTime;
    if (dropCounter > dropInterval) {
        player.pos.y++;
        dropCounter = 0;
    }
    
    draw();
    requestAnimationFrame(update); 
} 

// setInterval(update() , 1000);

const player = {
    position: {x: 5, y: 5},
    matrix: matrix,
}

update();