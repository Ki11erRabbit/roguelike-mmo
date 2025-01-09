extends Node3D

const GroundNormal = preload("res://World/Ground/ground_normal.tscn")
const CliffFront = preload("res://World/Cliffs/cliff_short_front.tscn")

const CHUNK_SIZE = 32
const CLIFF_LIMIT = 0.3

func generate_chunk(noise):
	
	var cells = []
	for x in CHUNK_SIZE:
		for y in CHUNK_SIZE:
			var out = noise.get_noise_2d(position.x + x, position.z + y)
			
			var node
			if out < CLIFF_LIMIT:
				node = GroundNormal.instantiate()
			else:
				node = CliffFront.instantiate()
			
			add_child(node)
			node.position.x = 0.5 + x
			node.position.z = 0.5 + y

#func _ready() -> void:
	#var noise = FastNoiseLite.new()
	#noise.seed = 100
	#generate_chunk(noise)
