class RedTetris
    def initialize args
        @args = args
        @next_move = 30
        @gameover = false
        @grid_w = 10
        @grid_h = 20
        @current_piece_x = 5
        @current_piece_y = 0
        @current_piece = [ [ 1, 1], [ 1, 1 ] ]
        @grid = []
        for x in 0..@grid_w-1 do
            @grid[x] = []
            for y in 0..@grid_h-1 do
                @grid[x][y] = 0
            end
        end
    end

    # X AND Y ARE POSITIONS IN THE GRID, NOT PIXELS
    def render_cube x, y, r, g, b, a=255
        boxsize = 30
        grid_x = (1280 - (@grid_w * boxsize)) / 2
        grid_y = (720 - ((@grid_h-2) * boxsize)) / 2
        @args.outputs.solids << [ grid_x + (x * boxsize), (720 - grid_y) - (y * boxsize), boxsize, boxsize, r, g, b, a ]
    end

    def render_grid
        for x in 0..@grid_w-1 do
            for y in 0..@grid_h-1 do
                render_cube x, y, 255, 255, 0 if @grid[x][y] != 0
            end
        end
    end

    def render_grid_border
        x = -1
        y = -1
        w = @grid_w + 2
        h = @grid_h + 2
        color = [ 255, 255, 255 ]
        for i in x..(x+w)-1 do
            render_cube i, y, *color
            render_cube i, (y+h)-1, *color
        end
        for i in y..(y+h)-1 do
            render_cube x, i, *color
            render_cube (x+w)-1, i, *color
        end
    end

    def render_background
        @args.outputs.solids << [ 0, 0, 1280, 720, 0, 0, 0 ]
        render_grid_border
    end

    def render_current_piece
        for x in 0..@current_piece.length-1 do
            for y in 0..@current_piece[x].length-1 do
                render_cube @current_piece_x + x, @current_piece_y + y, 255, 255, 0 if @current_piece[x][y] != 0
            end
        end
    end

    def render
        render_background
        render_grid
        render_current_piece
        #render_score
    end

    def current_piece_colliding
        for x in 0..@current_piece.length-1 do
            for y in 0..@current_piece[x].length-1 do
                if (@current_piece[x][y] != 0)
                    if (@current_piece_y + y >= @grid_h-1)
                        return true
                    elsif (@grid[@current_piece_x + x][@current_piece_y + y] != 0)
                        return true
                    end
                end
            end
        end
        return false
    end

    def select_next_piece
        @current_piece = case rand(7) #randomize the 6 tetrominos
            when 0 then [[0,1],[0,1],[1,1]]
            when 1 then [[1,1],[0,1],[0,1]]
            when 2 then [[1, 1, 1, 1]]
            when 3 then [[1,0],[1,1],[0,1]]
            when 4 then [[0,1],[1,1],[1,0]]
            when 5 then [[1,1],[1,1]]
            when 6 then [[0,1],[1,1],[0,1]]
        end
    end

    def plant_current_piece
        # Make this part of the landscape
        for x in 0..@current_piece.length-1 do
            for y in 0..@current_piece[x].length-1 do
                if @current_piece[x][y] != 0
                    @grid[@current_piece_x + x][@current_piece_y + y] = @current_piece[x][y]
                end
            end
        end
        @current_piece_y = 0
    end

    def iterate
    k = @args.inputs.keyboard
    if (@current_piece_x > 0)
        if k.key_down.left
            @current_piece_x -= 1
        end
    end
    
    if (@current_piece_x + @current_piece.length) < @grid_w
        if k.key_down.right
            @current_piece_x += 1
        end
    end

    if k.key_down.down || k.key_held.down
        @next_move -= 10
    end
   
       @next_move -= 1
        if @next_move <= 0  # drop the piece!
            if current_piece_colliding
                plant_current_piece
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
