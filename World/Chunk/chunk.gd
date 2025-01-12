extends Node3D



const GroundNormal = preload("res://World/Ground/ground_normal.tscn")
const CliffFront = preload("res://World/Cliffs/cliff_short_front.tscn")

const CHUNK_SIZE = 8
enum GridValue { 
	BottomlessPit = 0,
	Ground = 1, Hill = 3, ShortCliff = 5, TallCliff = 7,
	CliffCorner = 8,
	River = 16, RiverEdge = 32, Lake = 64, LakeEdge = 128,
	Barrier = 256,
}

var grid: Array[GridValue]

func get_tall_cliff_limit() -> float:
	return 0.5

func get_short_cliff_limit() -> float:
	return 0.3

func get_hill_limit() -> float:
	return 0.1

func get_ground_limit() -> float:
	return 0


func generate_chunk(cliff_noise):
	grid = []
	grid.resize(CHUNK_SIZE ** 2)
	generate_hills_and_mountains(cliff_noise)


func generate_hills_and_mountains(noise) -> void:
	for x in CHUNK_SIZE:
		for y in CHUNK_SIZE:
			var out = noise.get_noise_2d((position.x + x) * CHUNK_SIZE, position.z + y)
			#print(out)
			if out < get_ground_limit():
				grid[x * CHUNK_SIZE + y] = GridValue.BottomlessPit
			if out < get_hill_limit():
				grid[x * CHUNK_SIZE + y] = GridValue.Ground
			if out < get_short_cliff_limit():
				grid[x * CHUNK_SIZE + y] = GridValue.Hill
			elif out < get_tall_cliff_limit():
				grid[x * CHUNK_SIZE + y] = GridValue.ShortCliff
			else:
				grid[x * CHUNK_SIZE + y] = GridValue.TallCliff
	#print(grid)

func set_grid(x: int, y: int, value: GridValue) -> void:
	assert(x != CHUNK_SIZE, "x is equal to chunk size")
	grid[x + y * CHUNK_SIZE] = value

func update_grid(x: int, y: int, value: GridValue) -> void:
	assert(x != CHUNK_SIZE, "x is equal to chunk size")
	grid[x + y * CHUNK_SIZE] |= value

func row_to_string(row: int) -> String:
	var output = ""
	#print(row)
	#print(position)
	for i in range(row * CHUNK_SIZE, (row + 1) * CHUNK_SIZE):
		var flag: int = grid[i] & GridValue.River
		if flag != 0:
			output += "r"
		else:
			output += "0"
	return output


func place_world_meshes():
	for x in CHUNK_SIZE:
		for y in CHUNK_SIZE:
			var node
			if GridValue.TallCliff == grid[x * CHUNK_SIZE + y] & GridValue.TallCliff:
				node = CliffFront.instantiate()
			elif GridValue.ShortCliff == (grid[x * CHUNK_SIZE + y] & GridValue.ShortCliff):
				node = CliffFront.instantiate()
			elif GridValue.Hill == grid[x * CHUNK_SIZE + y] & GridValue.Hill:
				node = GroundNormal.instantiate()
			elif GridValue.Ground == (grid[x * CHUNK_SIZE + y] & GridValue.Ground):
				node = GroundNormal.instantiate()
			
			
			
			add_child(node)
			node.position.x = 0.5 + x
			node.position.z = 0.5 + y
				

#func _ready() -> void:
	#var noise = FastNoiseLite.new()
	#noise.seed = 100
	#generate_chunk(noise)
