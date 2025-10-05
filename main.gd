extends Node

@export var levels: Array[LevelParams] = []

@onready var world: Node2D = $World
@onready var interface: Control = $Interface

const LEVEL = preload("uid://bmibhdkm6qlta")
const START_SCREEN = preload("uid://csdn3xie7xdtu")

var current := -1

func _ready() -> void:
	var start: StartScreen = START_SCREEN.instantiate()
	start.start_pressed.connect(_on_start_pressed)
	interface.add_child(start)

	
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


func _on_start_pressed():
	for child in interface.get_children():
		child.queue_free()
	next_level()

func _on_level_finished():
	next_level()
