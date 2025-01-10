extends Node3D

@export
var noise: FastNoiseLite


const GroundNormal = preload("res://World/Ground/ground_normal.tscn")
const CliffFront = preload("res://World/Cliffs/cliff_short_front.tscn")

const CHUNK_SIZE = 32
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
	grid.resize(32 * 32)
	generate_hills_and_mountains(cliff_noise)

func generate_hills_and_mountains(noise) -> void:
	for x in CHUNK_SIZE:
		for y in CHUNK_SIZE:
			var out = noise.get_noise_2d(position.x + x, position.z + y)
			
			if out < get_ground_limit():
				grid[x * y] = GridValue.BottomlessPit
			if out < get_hill_limit():
				grid[x * y] = GridValue.Ground
			if out < get_short_cliff_limit():
				grid[x * y] = GridValue.Hill
			elif out < get_tall_cliff_limit():
				grid[x * y] = GridValue.ShortCliff
			else:
				grid[x * y] = GridValue.TallCliff

func set_grid(x: int, y: int, value: GridValue) -> void:
	grid[x * y] = value

func update_grid(x: int, y: int, value: GridValue) -> void:
	grid[x * y] |= value

#func _ready() -> void:
	#var noise = FastNoiseLite.new()
	#noise.seed = 100
	#generate_chunk(noise)
