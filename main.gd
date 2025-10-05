extends Node

@export var levels: Array[LevelParams] = []

@onready var world: Node2D = $World

const LEVEL = preload("uid://bmibhdkm6qlta")

var current := -1

func _ready() -> void:
	next_level()
	
func next_level():
	current += 1
	assert(current < len(levels), "No more levels!!!")
	
	var params: LevelParams = levels[current]
	assert(params != null, "Level %d is undefined!" % current)
	var new_level: Level = LEVEL.instantiate()
	new_level.params = params
	new_level.finished.connect(_on_level_finished)

	for child in world.get_children():
		world.remove_child(child)
	world.add_child(new_level)


func _on_level_finished():
	next_level()
