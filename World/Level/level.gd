class_name Level extends Node

const Chunk = preload("res://World/Chunk/chunk.tscn")
const ChunkS = preload("res://World/Chunk/chunk.gd")

var diameter: int = 8
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
	
	generate_rivers(seed, 20, 0.8)
	print_rows()

func generate_rivers(seed: int, points: int, threshold: float) -> void:
	var astargrid = AStarGrid2D.new()
	astargrid.region = Rect2i(0, 0, diameter * chunk_size, diameter * chunk_size)
	astargrid.cell_size = Vector2i(1, 1)
	#astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astargrid.update()
	
	var rng = RandomNumberGenerator.new()
	rng.seed = seed
	var size: int = chunk_size * diameter
	positions.resize(size)
	for i in size:
		var row = ""
		for j in size:
			var value = rng.randf_range(0.0, 1.0)
			if value >= threshold:
				#print("adding blocker")
				astargrid.set_point_solid(Vector2i(i, j))
				row += "B"
			else:
				row += "0"
		print(row)
	
	var point_positions: Array[Vector2i] = []
	point_positions.resize(points)
	for i in points:
		var x: int = -1
		var y: int = -1
		while x == -1 and y == -1:
			x = rng.randi_range(0, chunk_size * diameter -1)
			y = rng.randi_range(0, chunk_size * diameter -1)
			if astargrid.is_point_solid(Vector2i(x, y)):
				x = -1
				y = -1
		point_positions[i] = Vector2i(x, y)
	
	#for i in diameter * chunk_size:
		#var row: String = ""
		#for j in diameter * chunk_size:
			#row += " {0} ".format([positions[i + j]])
		#print(row)
	
	print("")
	
	for i in range(0, point_positions.size() - 1):
		for j in range(1, point_positions.size()):
			#print("performing a*")
			#print(point_positions[i])
			#print(point_positions[i + 1])
			var path = astargrid.get_point_path(point_positions[i], point_positions[i + 1])
			for pos in path:
				#print(pos)
				update_grid(pos.x, pos.y, ChunkS.GridValue.River)
		#print("performing a*")
		#print(point_positions[i])
		#print(point_positions[i + 1])
		#var path = astargrid.get_point_path(point_positions[i], point_positions[i + 1])
		#for pos in path:
			#print(pos)
			#update_grid(pos.x, pos.y, ChunkS.GridValue.River)
		
		
		




func set_grid(x: int, y: int, value: ChunkS.GridValue) -> void:
	var x_count: int = 0
	var y_count: int = 0
	while x > chunk_size:
		x -= chunk_size
		x_count += 1
	while y > chunk_size:
		y -= chunk_size
		y_count += 1
	
	get_child(x_count * y_count).set_grid(x, y, value)

func update_grid(x: int, y: int, value: ChunkS.GridValue) -> void:
	#print("old x: {0}".format([x]))
	#print("old y: {0}".format([y]))
	var x_count: int = 0
	var y_count: int = 0
	while x > chunk_size:
		x -= chunk_size
		x_count += 1
	while y > chunk_size:
		y -= chunk_size
		y_count += 1
	
	#print("new x: {0}".format([x]))
	#print("new y: {0}".format([y]))
	#print("x_count: {0}".format([x_count * diameter]))
	#print("y_count: {0}".format([y_count]))
	get_child(x_count * diameter + y_count).update_grid(x, y, value)

func print_rows():
	print("Printing Rows")
	for i in chunk_size:
		for j in diameter:
			var row: String = ""
			for k in diameter:
				#print("j + k: {0}".format([k + j]))
				#print("i: {0}".format([i]))
				row += get_child(j * diameter + k).row_to_string(i)
			print(row)

func _ready() -> void:
	generate_level(10)
