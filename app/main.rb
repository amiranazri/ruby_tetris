$gtk.reset

class RedTetris
    def initialize args
        @args = args
        @new_tetrimino = nil
        @next_move = 30
        @score = 0
        @gameover = false
        @grid_width = 10
        @grid_height = 20
        @grid = []
        for x in 0..@grid_width-1 do
            @grid[x] = []
            for y in 0..@grid_height-1 do
                @grid[x][y] = 0
            end
        end

        @color_picker = [
            [0, 0, 0],
            [255, 102, 102],
            [255, 255, 102],
            [178, 255, 102],
            [153, 255, 255],
            [178, 102, 255],
            [255, 178, 102],
            [127, 127, 127]
        ]

        randomize_tetrimino
        randomize_tetrimino
    end

    # X AND Y ARE POSITIONS IN THE GRID, NOT PIXELS
    def render_tetrimino x, y, color
        gridsize = 30
        grid_x = (1280 - (@grid_width * gridsize)) / 2
        grid_y = (720 - ((@grid_height-2) * gridsize)) / 2
        @args.outputs.solids << [grid_x + (x * gridsize), (720 - grid_y) - (y * gridsize), gridsize, gridsize, *@color_picker[color]]
        @args.outputs.borders << [grid_x + (x * gridsize), (720 - grid_y) - (y * gridsize), gridsize, gridsize, 255, 255, 255]
    end

    def render_grid
        for x in 0..@grid_width-1 do
            for y in 0..@grid_height-1 do
                render_tetrimino x, y, @grid[x][y] if @grid[x][y] != 0
            end
        end
    end

    def render_grid_border x, y, w, h
        color = 7
        for i in x..(x+w)-1 do
            render_tetrimino i, y, color
            render_tetrimino i, (y+h)-1, color
        end
        for i in y..(y+h)-1 do
            render_tetrimino x, i, color
            render_tetrimino (x+w)-1, i, color
        end
    end

    def render_background
        @args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
        render_grid_border -1, -1, @grid_width + 2, @grid_height + 2
    end

    def render_piece piece, piece_x, piece_y
        for x in 0..piece.length-1 do
            for y in 0..piece[x].length-1 do
                render_tetrimino piece_x + x, piece_y + y, piece[x][y] if piece[x][y] != 0
            end
        end
    end

    def render_current_piece
        render_piece @current_piece, @current_piece_x, @current_piece_y
    end

    def render_new_tetrimino
        # YUH BITCH: this is temporary, don't hardcode these numbers when submitting.
        render_grid_border 13, 2, 8, 8 #replace these numbers with static variables
        center_x = (8 - @new_tetrimino.length) / 2
        center_y = (8 - @new_tetrimino[0].length) / 2
        render_piece @new_tetrimino, 13 + center_x, 2 + center_y
        @args.outputs.labels << [910, 640, "Next piece", 10, 255, 255, 255, 255]
    end

    def render_score
        @args.outputs.labels << [75, 75, "Score: #{@score}", 10, 255, 255, 255, 255]
        @args.outputs.labels << [200, 450, "GAME OVER!", 100, 255, 255, 255, 255] if @gameover
    end

    def render
        render_background
        render_grid
        render_new_tetrimino
        render_current_piece
        render_score
    end

    #is colliding?
    def is_stacked
        for x in 0..@current_piece.length-1 do
            for y in 0..@current_piece[x].length-1 do
                if (@current_piece[x][y] != 0)
                    if (@current_piece_y + y >= @grid_height-1)
                        return true
                    elsif (@grid[@current_piece_x + x][@current_piece_y + y + 1] != 0)
                        return true
                    end
                end
            end
        end
        return false
    end

    def randomize_tetrimino
        @current_piece = @new_tetrimino
        X = rand(6) + 1
        @new_tetrimino = case X
            when 1 then [[X, X], [0, X], [0, X]]
            when 2 then [[X, X, X, X]]
            when 3 then [[X, 0], [X, X], [0, X]]
            when 4 then [[0, X], [X, X], [X, 0]]
            when 5 then [[X, X], [X, X]]
            when 6 then [[0, X], [X, X], [0, X]]
            when 7 then [[0, X], [0, X], [X, X]]
        end
        @current_piece_x = 5
        @current_piece_y = 0
    end

    def stack_tetrimino
        # Make this part of the landscape
        for x in 0..@current_piece.length-1 do
            for y in 0..@current_piece[x].length-1 do
                if @current_piece[x][y] != 0
                    @grid[@current_piece_x + x][@current_piece_y + y] = @current_piece[x][y]
                end
            end
        end

        # see if any rows need to be cleared out
        for y in 0..@grid_height-1
            full = true
            for x in 0..@grid_width-1
                if @grid[x][y] == 0
                    full = false
                    break
                end
            end

            if full  # no empty space in the row
                @score += 1
                for i in y.downto(1) do
                    for j in 0..@grid_width-1
                        @grid[j][i] = @grid[j][i-1]
                    end
                end
                for i in 0..@grid_width-1
                    @grid[i][0] = 0
                end
            end
        end

        randomize_tetrimino
        if is_stacked
            @gameover = true
        end
    end

    def rotate_left
        @current_piece = @current_piece.transpose.map(&:reverse)
        if (@current_piece_x + @current_piece.length) >= @grid_width
            @current_piece_x = @grid_width - @current_piece.length
        end
    end

    def rotate_right
        @current_piece = @current_piece.transpose.map(&:reverse)
        @current_piece = @current_piece.transpose.map(&:reverse)
        @current_piece = @current_piece.transpose.map(&:reverse)
        if (@current_piece_x + @current_piece.length) >= @grid_width
            @current_piece_x = @grid_width - @current_piece.length
        end
    end

    def iterate
        # Check input!
        k = @args.inputs.keyboard

        if @gameover
            if k.key_down.space
                $gtk.reset
            end
            return
        end

        if k.key_down.left
            if @current_piece_x > 0
                @current_piece_x -= 1
            end
        end

        if k.key_down.right
            if (@current_piece_x + @current_piece.length) < @grid_width
                @current_piece_x += 1
            end
        end

        if k.key_down.down || k.key_held.down
            @next_move -= 10
        end

        if k.key_down.a
            rotate_left
        end

        if k.key_down.s
            rotate_right
        end

        @next_move -= 1
        if @next_move <= 0  # drop gurl
            if is_stacked
                stack_tetrimino
            else
                @current_piece_y += 1
            end
            @next_move = 30
        end
    end

    def tick
        iterate
        render
    end
end

def tick args
    args.state.game ||= RedTetris.new args
    args.state.game.tick
end