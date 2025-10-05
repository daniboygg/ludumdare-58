extends Node

@export var levels: Array[LevelParams] = []

@onready var world: Node2D = $World
@onready var interface: Control = %Interface

const LEVEL = preload("uid://bmibhdkm6qlta")
const START_SCREEN = preload("uid://csdn3xie7xdtu")
const POPUP_SCREEN = preload("uid://eelsmiam16di")

func _ready() -> void:
	var start: StartScreen = START_SCREEN.instantiate()
	start.start_pressed.connect(_on_start_pressed)
	interface.add_child(start)

	
func next_level():
	Globals.current_level += 1
	assert(Globals.current_level < len(levels), "No more levels!!!")
	
	var params: LevelParams = levels[Globals.current_level]
	assert(params != null, "Level %d is undefined!" % Globals.current_level)
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
	var popup: PopupScreen = POPUP_SCREEN.instantiate()
	interface.add_child(popup)
	popup.button_pressed.connect(_on_button_pressed)
	popup.title.text = "Congratulations!"
	popup.text.text = "You completed\nprogram_%02d" % Globals.current_level
	popup.button.text = "Next"
	
	
func _on_button_pressed():
	for child in interface.get_children():
		child.queue_free()
	
	next_level()
