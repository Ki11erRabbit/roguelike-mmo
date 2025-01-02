class_name WeaponStats extends Resource

var kind: StringName
var handedness: StringName
var level: int
var attack: int
var weight: int
var durability: int
var current_durability: int
var range: int
var length: float

func initialize(resource: Resource):
	self.level = resource.level
	self.attack = resource.attack
	self.weight = resource.weight
	self.durability = resource.durability
	self.current_durability = resource.current_durability
	self.range = resource.range
	self.kind = resource.kind
	self.handedness = resource.handedness
