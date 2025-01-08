class_name Character extends CharacterBody3D

var id: int = GlobalId.get_id()
var last_position: Vector3 = position
var player_id: int = 1

var client_updater: PlayerClientUpdater:
	set(value):
		value.character = self
		client_updater = value
		add_child(value)
var server_updater: PlayerServerUpdater

var movement_state_machine: MovementStateMachine = MovementStateMachine.new()
var right_weapon: Weapon
var right_hand_weapon: WeaponStateMachine
var left_weapon: Weapon
var left_hand_weapon: WeaponStateMachine

var weapons_equiped: bool = false
enum AirState { Grounded, Jumping, Falling, Landing }
var air_state: AirState = AirState.Grounded

var model: CharacterModel

@export
var control_box: ControlBox

@export
var stats: CharacterStats

signal health_hit_zero
signal grace_period_ended

var current_health: float = 0

var regen_timer: float = 0.0

var damage: float = 0
var damage_rate: float = 80 / 60

var healing: float = 0

var healing_rate: float = 100 / 60

@onready
var timer: Timer = $Timer
var started_timer: bool = false
const GRACE_PERIOD: int = 10

@onready
var collision_box: CollisionShape3D = $CollisionShape3D

var weapons_waiting_for_cooldown: Dictionary = {}

var health_bar: HealthBar
var camera: Camera3D

func attach_health_bar(bar: HealthBar, camera: Camera3D) -> void:
	health_bar = bar
	self.camera = camera


## This should be called in ready_character
func initialize(model: CharacterModel, collision_shape: CapsuleShape3D, box: ControlBox):
	self.model = model
	self.model.model.initialize(self)
	add_child(model)
	collision_box.shape = collision_shape
	control_box = box
	movement_state_machine.initialize(self)

func ground():
	air_state = AirState.Grounded
func is_grounded():
	match air_state:
		AirState.Grounded:
			return true
	return false
func jump():
	air_state = AirState.Jumping
func is_jumping():
	match air_state:
		AirState.Jumping:
			return true
	return false
func fall():
	air_state = AirState.Falling
func is_falling():
	match air_state:
		AirState.Falling:
			return true
	return false
func land():
	air_state = AirState.Landing
func is_landing():
	match air_state:
		AirState.Landing:
			return true
	return false

func attach_right_hand_weapon(weapon: Weapon, state_machine: WeaponStateMachine):
	right_hand_weapon = state_machine
	right_weapon = weapon
	weapon.stats.hand = "right"

func attach_left_hand_weapon(weapon: Weapon, state_machine: WeaponStateMachine):
	left_hand_weapon = state_machine
	left_weapon = weapon
	weapon.stats.hand = "left"

func attach_two_handed_weapon(weapon: Weapon, state_machine: WeaponStateMachine):
	right_hand_weapon = state_machine
	left_hand_weapon = state_machine
	right_weapon = weapon
	weapon.stats.hand = "both"

func switch_to_two_handed(right: bool):
	unequip()
	if right:
		left_hand_weapon = right_hand_weapon
	else:
		right_hand_weapon = left_hand_weapon
	right_weapon.stats.hand = "both"
	equip("both")

func switch_to_one_handed(right: bool):
	unequip()
	if right:
		right_weapon.stats.hand = "right"
		left_hand_weapon = null
		equip("right")
	else:
		left_weapon.stats.hand = "left"
		right_hand_weapon = null
		equip("left")

func unequip():
	model.unequip()

func equip(hand: String):
	model.equip(hand)

func equip_weapons():
	model.equip_weapons(right_weapon, left_weapon)
	weapons_equiped = true

func unequip_weapons():
	var pair: Array[Node3D] = model.unequip_weapons()
	weapons_equiped = false

func play_animation(anim_name: String, weapon: String, hand: String):
	model.play_animation(anim_name, weapon, hand)

func play_body_animation(anim_name: String):
	model.play_body_animation(anim_name)

## returns: Return value is a boolean indicating whether or not to not process other character functions
## true means to skip other character functions
func process_character(delta: float) -> bool:
	return false

func ready_character():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if server_updater != null:
		server_updater.character = self
		add_child(server_updater)
	ready_character()
	current_health = stats.current_health
	if health_bar != null:
		health_bar.update_current_value(current_health)
		health_bar.update_max_health(stats.max_health)
		health_bar.interpret_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	process_health(delta)
	
	process_health_bar_position()
	
	if process_character(delta):
		control_box.tick(delta)
		return
	movement_state_machine.process_state(delta)
	if weapons_equiped:
		var right_action: WeaponAction = null
		var left_action: WeaponAction = null
		if right_hand_weapon != null:
			right_hand_weapon.enabled = true
			right_action = right_hand_weapon.process_input(delta)
		if left_hand_weapon != null:
			left_hand_weapon.enabled = true
			left_action = left_hand_weapon.process_input(delta)
		
		var right_priority: int = -1
		var left_priority: int = -1
		
		if right_action != null:
			right_priority = right_action.priority
		if left_action != null:
			left_priority = left_action.priority
		
		if right_priority > left_priority:
			right_action.perform_action()
		elif left_priority > right_priority:
			left_action.perform_action()
		elif right_priority != -1 and left_priority != -1:
			right_action.perform_action()
			left_action.perform_action()
		
	elif right_hand_weapon != null and left_hand_weapon != null:
		if right_hand_weapon != null:
			right_hand_weapon.enabled = false
		if left_hand_weapon != null:
			left_hand_weapon.enabled = false
	
	move_and_slide()
	post_move_and_slide(delta)
	control_box.tick(delta)
	

func post_move_and_slide(delta: float) -> void:
	pass

## A function meant to be overridden to facilitate any needed additional function when a weapon collides with the character
func weapon_collided(weapon: Weapon):
	pass

## Returns null if weapon has already collided with the character
## Returns the current character if the weapon hasn't collided yet
func collide_weapon(weapon: Weapon) -> Character:
	if weapon.get_id() in weapons_waiting_for_cooldown:
		return null
	else:
		if not weapon.done_attacking.is_connected(clear_weapon):
			weapon.done_attacking.connect(clear_weapon)
		weapons_waiting_for_cooldown[weapon.get_id()] = weapon.get_id()
		weapon_collided(weapon)
		return self

func clear_weapon(weapon_id: int):
	weapons_waiting_for_cooldown.erase(weapon_id)

func add_damage(amount: int):
	damage += amount
	server_updater.send_damage(amount)

func recv_damage(amount: int):
	damage += amount

func add_healing(amount: int):
	healing += amount
	server_updater.send_healing(amount)

func recv_healing(amount: int):
	healing += amount

func start_timer():
	if not started_timer:
		started_timer = true
		timer.start()

func reset_timer():
	if started_timer:
		started_timer = false
		timer.stop()
		timer.wait_time = GRACE_PERIOD

func process_health(delta: float):
	
	if stats.current_health != stats.max_health and stats.current_health != 0:
		if regen_timer >= stats.health_regen_cooldown:
			regen_timer = 0
			healing += stats.max_health * (stats.health_regen_percentage / 100)
		else:
			regen_timer += delta
	else:
		regen_timer = 0.0
			
	
	if damage > 0:
		if damage - damage_rate < 0:
			current_health -= damage
		else:
			damage -= damage_rate
			current_health -= damage_rate
			#print(damage_rate)
	
	if damage <= 0:
		damage = 0
	
	if healing > 0:
		if healing - healing_rate < 0:
			current_health += healing
		else:
			healing -= healing_rate
			current_health += healing_rate
	
	if healing <= 0:
		healing = 0
	
	if current_health <= 0 and not started_timer and healing <= 0:
		current_health = 0
		emit_signal("health_hit_zero")
		start_timer()
	elif started_timer and healing > 0:
		reset_timer()
	
	if current_health >= stats.max_health:
		current_health = stats.max_health
	
	stats.current_health = int(ceil(current_health))
	if health_bar == null:
		return
	health_bar.update_current_value(current_health)
	health_bar.interpret_color()
	

func process_health_bar_position():
	return
	var screen_pos = camera.unproject_position(self.global_position)
	health_bar.global_position = screen_pos
	health_bar.global_position.x -= health_bar.size.x / 2
	health_bar.global_position.y -= health_bar.size.y * 4

func get_id() -> int:
	return id
