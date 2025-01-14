class_name Level extends Node

const Chunk = preload("res://World/Chunk/chunk.tscn")
const ChunkS = preload("res://World/Chunk/chunk.gd")

var diameter: int = 32
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
	
	print("generating rivers")
	generate_rivers(seed, 10, 20, 50, 20, 2, 5)
	print_rows()
	for child in get_children():
		#print("placing world meshes")
		child.place_world_meshes()

enum JunctionDirection { Up, Down, Left, Right }

func generate_rivers(seed: int, river_count: int, min_distance: int, max_distance: int, total_junctions: int, min_radius: int, max_radius: int) -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = seed
	
	while river_count != 0:
		river_count -= 1
		var x: int = rng.randi_range(0, diameter * chunk_size -1)
		var y: int = rng.randi_range(0, diameter * chunk_size -1)
		
		var max_junctions: int = rng.randi_range(2, total_junctions)
		var points1: Array[Vector2i] = [Vector2i(x, y)]
		var points2: Array[Vector2i] = [Vector2i(x, y)]
		var direction: JunctionDirection = river_reach_end(min_distance, max_distance, int(ceil(max_junctions / 2)), -1, rng, points1)
		
		river_reach_end(min_distance, max_distance, int(ceil(max_junctions / 2)), direction, rng, points2, 0)
		
		#print(points1)
		#print(points2)
		
		widen_river(min_radius, max_radius, points1 + points2, rng)
		for point in points1 + points2:
			update_grid(point.x, point.y, ChunkS.GridValue.River)

func river_reach_end(min_distance: int, max_distance: int, junctions: int, last_direction: JunctionDirection, rng: RandomNumberGenerator, points: Array[Vector2i], index: int = -1) -> JunctionDirection:
	if junctions == 0:
		# Here we try to reach the end by following the last direction until we hit the end of the map
		var x_factor: int = 0
		var y_factor: int = 0
		match last_direction:
			JunctionDirection.Up:
				y_factor = -1
				#print("Up")
			JunctionDirection.Down:
				y_factor = 1
				#print("Down")
			JunctionDirection.Left:
				x_factor = -1
				#print("Left")
			JunctionDirection.Right:
				x_factor = 1
				#print("Right")
		assert(x_factor != 0 or y_factor != 0, "x or y factor should not be zero")
		while true:
			#print("trying to reach end")
			var last_position: Vector2i = points[points.size() - 1]
			var new_point: Vector2i = Vector2i(last_position.x + x_factor, last_position.y + y_factor)
			if point_not_valid(new_point):
				# We have reached the end
				return last_direction
			points.push_back(new_point)
	
	var direction: JunctionDirection = -1
	while direction == last_direction or direction == -1:
		direction = rng.randi_range(JunctionDirection.Up, JunctionDirection.Right)
	var distance: int = rng.randi_range(min_distance, max_distance)
	var x_factor: int = 0
	var y_factor: int = 0
	match direction:
		JunctionDirection.Up:
			y_factor = -1
			#print("Up")
		JunctionDirection.Down:
			y_factor = 1
			#print("Down")
		JunctionDirection.Left:
			x_factor = -1
			#print("Left")
		JunctionDirection.Right:
			x_factor = 1
			#print("Right")
	assert(x_factor != 0 or y_factor != 0, "x or y factor should not be zero")
	if index == -1:
		index = points.size() - 1
	while distance != 0:
		distance -= 1
		var last_position: Vector2i = points[index]
		var new_point: Vector2i = Vector2i(last_position.x + x_factor, last_position.y + y_factor)
		if point_not_valid(new_point):
			# We have reached the end
			return direction
		index += 1
		points.push_back(new_point)
	
	river_reach_end(min_distance, max_distance, junctions - 1, direction, rng, points)
	return direction

func widen_river(min_radius: int, max_radius: int, points: Array[Vector2i], rng: RandomNumberGenerator):
	var middle_radius: int = rng.randi_range(min_radius, max_radius)
	for point in points:
		var radius: int = rng.randi_range(middle_radius, max_radius)
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				var coords: Vector2i = Vector2i(x, y)
				if coords.length() <= radius:
					var pos: Vector2i = Vector2i(point.x + coords.x, point.y + coords.y)
					if point_not_valid(pos):
						continue
					update_grid(pos.x, pos.y, ChunkS.GridValue.River)
						


func point_not_valid(point: Vector2i) -> bool:
	var x: int = point.x
	var y: int = point.y
	if x < 0 or y < 0:
		return true
	var x_count: int = 0
	var y_count: int = 0
	while x >= chunk_size:
		x -= chunk_size
		x_count += 1
	while y >= chunk_size:
		y -= chunk_size
		y_count += 1
	
	if x_count >= diameter or y_count >= diameter:
		return true
	if x == chunk_size or y == chunk_size:
		return true
	return false

func set_grid(x: int, y: int, value: ChunkS.GridValue) -> void:
	var x_count: int = 0
	var y_count: int = 0
	while x >= chunk_size:
		x -= chunk_size
		x_count += 1
	while y >= chunk_size:
		y -= chunk_size
		y_count += 1
	
	get_child(x_count + y_count * diameter).set_grid(x, y, value)

func update_grid(x: int, y: int, value: ChunkS.GridValue) -> void:
	#print("old x: {0}".format([x]))
	#print("old y: {0}".format([y]))
	var x_count: int = 0
	var y_count: int = 0
	while x >= chunk_size:
		x -= chunk_size
		x_count += 1
	while y >= chunk_size:
		y -= chunk_size
		y_count += 1
	
	#print("new x: {0}".format([x]))
	#print("new y: {0}".format([y]))
	#print("x_count: {0}".format([x_count * diameter]))
	#print("y_count: {0}".format([y_count]))
	get_child(x_count + y_count * diameter).update_grid(x, y, value)

func print_rows():
	print("Printing Rows")
	
	for y in diameter:
		for r in chunk_size:
			var row: String = ""
			for x in range(0, diameter):
				#print(y * diameter + x)
				#print(r)
				row +=get_child(y * diameter + x).row_to_string(r)
			print(row)
	
	#for r in chunk_size:
		#for x in diameter:
			#var row: String = ""
			#for y in range(1, diameter):
				##print("j + k: {0}".format([k + j]))
				##print("i: {0}".format([i]))
				#row += get_child(x * diameter + y).row_to_string(r)
			#print(row)

#func _ready() -> void:
	#generate_level(100)
