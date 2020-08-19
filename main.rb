def init args
	args.state.score ||= 0
	args.state.gameover ||= false
	args.state.grid_width ||= 10
	args.state.grid_height ||= 20
	args.state.curr_tetromino_x ||= 5
	args.state.curr_tetromino_y ||= 0

	if args.state.grid.nil?
		args.state.grid = [ ]
		for x in 0..args.state.grid_width-1 do
			args.state.grid[x] = [ ]
			for y in 0..args.state.grid_height-1 do
				args.state.grid[x][y] = 0
			end
		end
	end
end

def render_bg args
	args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
end

#x and y are positions within my grid, not pixels.
def render_tetromino x, y, args
	grid_x = 0
	grid_y = 0
	args.outputs.solids << []
end

def render_grid

end

def	render args
	render_bg args
	render_grid
	#render_score
end

def tick args
	init args
	render args
end
