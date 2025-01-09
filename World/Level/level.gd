extends Node

const Chunk = preload("res://World/Chunk/chunk.tscn")

var level_size: int = 16

func generate_level(seed: int) -> void:
	var noise = FastNoiseLite.new()
	noise.seed = seed
	for x in level_size:
		for y in level_size:
			var chunk = Chunk.instantiate()
			add_child(chunk)
			chunk.position.x = x * chunk.CHUNK_SIZE
			chunk.position.z = y * chunk.CHUNK_SIZE
			chunk.generate_chunk(noise)
			

func _ready() -> void:
	generate_level(100)
