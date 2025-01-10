class_name Level extends Node

const Chunk = preload("res://World/Chunk/chunk.tscn")
const ChunkS = preload("res://World/Chunk/chunk.gd")

var diameter: int = 16
var chunk_size: int = 0
var positions = []

func generate_level(seed: int) -> void:
	var noise = FastNoiseLite.new()
	noise.seed = seed
	# TODO: add code to place -1 in positions that are outside of the circle
	for x in diameter:
		for y in diameter:
			var chunk = Chunk.instantiate()
			if chunk_size == 0:
				chunk_size = chunk.CHUNK_SIZE
			add_child(chunk)
			chunk.position.x = x * chunk.CHUNK_SIZE
			chunk.position.z = y * chunk.CHUNK_SIZE
			chunk.generate_chunk(noise)
			

func generate_rivers(seed: int, points: int, river_count: int) -> void:
	var chunk_size: int = Chunk.instantiate().CHUNK_SIZE
	var rng = RandomNumberGenerator.new()
	rng.seed = seed
	var size: int = chunk_size * chunk_size * diameter * diameter
	positions.resize(size)
	for i in size:
		var value = rng.randf_range(0.0, 5.0)
		positions[i] = value
	
	var point_positions: Array[Vector2] = []
	point_positions.resize(points)
	for i in points:
		var x: int = -1
		var y: int = -1
		while x != -1 and y != -1:
			x = rng.randi_range(0, chunk_size * diameter + 1)
			y = rng.randi_range(0, chunk_size * diameter + 1)
			if positions[x * y] == -1:
				x = -1
				y = -1
		point_positions[i] = Vector2(x, y)
		positions[x * y] = 0
	
	

func river_a_star(x_size: int, y_size: int, start: Vector2, end: Vector2) -> void:
	var closed_list: Array[bool] = []
	var cell_details: Array[Dictionary] = []
	var closed_size = x_size * y_size
	closed_list.resize(closed_size)
	cell_details.resize(closed_size)
	for i in closed_size:
		closed_list[i] = false
		cell_details[i] = {
			"parent_i": 0, 
			"parent_j": 0, 
			"f": float('inf'), #total_cost
			"g": float('inf'), #cost_from_start
			"h": 0             #heuristic
		}
	
	var i: int = int(start.x)
	var j: int = int(start.y)
	cell_details[i * j]["f"] = 0
	cell_details[i * j]["g"] = 0
	cell_details[i * j]["h"] = 0
	cell_details[i * j]["parent_i"] = i
	cell_details[i * j]["parent_j"] = j
	
	var queue: PriorityQueue = PriorityQueue.new()
	queue.initialize([{"cost": 0.0, "x": i, "y": j}], func(x, y): 
		if x["cost"] < y["cost"]:
			return -1
		elif x["cost"] > y["cost"]:
			return 1
		else:
			return 0
	)
	var found_dest: bool = false
	
	
	var directions = [
		{"x": 0, "y": 1},
		{"x": 0, "y": -1},
		{"x": 1, "y": 0},
		{"x": -1, "y": 0},
		{"x": 1, "y": 1},
		{"x": 1, "y": -1},
		{"x": -1, "y": 1},
		{"x": -1, "y": -1},
	]
	while queue.size() > 0:
		var p = queue.delete_min()
		
		i = p["x"]
		j = p["y"]
		closed_list[i * j] = true
		for dir in directions:
			var new_i: int = i + dir["x"]
			var new_j: int = j + dir["y"]
			
			if a_star_is_valid(x_size, y_size, new_i, new_j) and not closed_list[new_i * new_j]:
				
				
				if a_star_is_at_end(new_i, new_j, end):
					cell_details[new_i * new_j]["parent_i"] = i
					cell_details[new_i * new_j]["parent_j"] = j
					print("found destination")
					found_dest = true
					return
				else:
					var g_new = cell_details[i * j]["g"] + 1.0
					var h_new = a_star_calculate_h_value(new_i, new_j, end)
					var f_new = g_new + h_new
					
					if cell_details[i * j]["f"] == float('inf') or cell_details[i * j]["f"] > f_new:
						queue.insert({"cost": f_new, "x": new_i, "y": new_j})
						
						cell_details[new_i * new_j]["f"] = f_new
						cell_details[new_i * new_j]["g"] = g_new
						cell_details[new_i * new_j]["h"] = h_new
						cell_details[new_i * new_j]["parent_i"] = i
						cell_details[new_i * new_j]["parent_j"] = j
	
	if not found_dest:
		print("Failed to find destination")

func a_star_is_valid(x_size: int, y_size: int, i: int, j: int) -> bool:
	return (i >= 0) and (i < x_size) and (j >= 0) and (j < y_size)

func a_star_is_at_end(i: int, j: int, end: Vector2) -> bool:
	return i == int(end.x) and j == int(end.y)

func a_star_calculate_h_value(i: int, j: int, end: Vector2) -> float:
	return ((i - int(end.x)) ** 2 + (j - int(end.y)) ** 2) ** 0.5

func set_grid(x: int, y: int, value: ChunkS.GridValue) -> void:
	var x_count: int = 0
	var y_count: int = 0
	while x > diameter:
		x -= chunk_size
		x_count += 1
	while y > diameter:
		y -= chunk_size
		y_count += 1
	
	get_child(x_count * y_count).set_grid(x, y, value)

func update_grid(x: int, y: int, value: ChunkS.GridValue) -> void:
	var x_count: int = 0
	var y_count: int = 0
	while x > diameter:
		x -= chunk_size
		x_count += 1
	while y > diameter:
		y -= chunk_size
		y_count += 1
	
	get_child(x_count * y_count).update_grid(x, y, value)

func _ready() -> void:
	generate_level(100)
