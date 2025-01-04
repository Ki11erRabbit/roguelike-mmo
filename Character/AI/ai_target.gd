class_name AITarget extends Node

var target: Character
var priority: int

func initialize(target: Character, priority: int):
	self.target = target
	self.priority = priority

func compare(other: AITarget):
	if self.priority < other.priority:
		return -1
	elif self.priority > other.priority:
		return 1
	else:
		if target.get_id() == other.get_id():
			return 0
		else:
			return 1

func get_id() -> int:
	return target.get_id()
