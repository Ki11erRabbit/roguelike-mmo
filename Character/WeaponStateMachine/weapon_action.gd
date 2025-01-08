class_name WeaponAction extends Node

var animation_name: String
var weapon: String
var hand: String

var body_animation: String
var character: Character
var priority: int = 0

func initialize(character: Character):
	self.character = character

func set_animation(anim_name: String, weapon: String, hand: String) -> void:
	self.animation_name = anim_name
	self.weapon = weapon
	self.hand = hand

func set_body_animation(anim_name: String) -> void:
	self.body_animation = anim_name

func set_priority(value: int) -> void:
	priority = value

func perform_action() -> void:
	character.play_animation(animation_name, weapon, hand)
	if body_animation != "":
		character.play_body_animation(body_animation)
		body_animation = ""
	
