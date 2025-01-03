class_name WeaponStats extends Resource

## The weapon's type
@export
var kind: StringName
## Whether or not the weapon is 2-handed or one handed
@export
var handedness: StringName
## The minimum level required to equip
@export
var level: int
## The base attack stat the sword has
@export
var attack: int
## The length of the area of the sword that is not the blade
@export
var length: float
## How much damage can the blade take before breaking
@export
var durability: int
## The current durability value of the weapon.
@export
var current_durability: int
## The size of the hitbox of the weapon
@export
var range: float
## The offset which the main hand with be positioned on the sword
@export
var hand_position: float

func initialize(resource: Resource):
	self.level = resource.level
	self.attack = resource.attack
	self.weight = resource.weight
	self.durability = resource.durability
	self.current_durability = resource.current_durability
	self.range = resource.range
	self.length = resource.length
	self.kind = resource.kind
	self.handedness = resource.handedness
	self.hand_position = resource.hand_position
