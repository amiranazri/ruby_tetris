 def init args
    #args.state.score ||= 0
    args.state.gameover ||= false
    args.state.grid_w ||= 10
    args.state.grid_h ||= 20
    args.state.current_piece_x ||= 5
    args.state.current_piece_y ||= 0

    if args.state.grid.nil?
        args.state.grid = []
        for x in 0..args.state.grid_w-1 do
            args.state.grid[x] = []
            for y in 0..args.state.grid_h-1 do
                args.state.grid[x][y] = 0
            end
        end
    end
end

def render_cube args, x, y 
	grid_x = 100
	grid_y = 50
	boxsize = 100
	args.outputs.solids << [ grid_x + (x),  (720 - grid_y) - (y), boxsize, 255, 0, 0, 255 ]
end

def render_grid args
    #for x in 0..args.state.grid_w-1 do
    	#for y in 0..args.state.grid_h-1 do
    	#render_cube x, y
   	 #end
    #end
end

def render_background args
    args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
end

def render args
    render_grid args
    render_background args
    #render_cube args
    #render_score
end

def tick args
	x = 1
	y = 1
	i = 0
	j = 0
    init args
    render args
    while i < 100 do
	i += 1
	while j < 500 do
		j += 1
	end
	j = 0
	render_cube args, x + 200, y + 200
    end
end
