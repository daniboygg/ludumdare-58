extends Node

@export var levels: Array[LevelParams] = []

@onready var world: Node2D = $World
@onready var interface: Control = %Interface

const LEVEL = preload("uid://bmibhdkm6qlta")
const START_SCREEN = preload("uid://csdn3xie7xdtu")
const POPUP_SCREEN = preload("uid://eelsmiam16di")

func _ready() -> void:
	start_game()


func start_game():
	for child in interface.get_children():
		child.queue_free()
	for child in world.get_children():
		world.remove_child(child)
	
	Globals.current_level = -1
	var start: StartScreen = START_SCREEN.instantiate()
	start.start_pressed.connect(_on_start_pressed)
	interface.add_child(start)


func next_level():
	Globals.current_level += 1
	if Globals.current_level >= len(levels):
		finish_screen()
		return
	
	var params: LevelParams = levels[Globals.current_level]
	assert(params != null, "Level %d is undefined!" % Globals.current_level)
	var new_level: Level = LEVEL.instantiate()
	new_level.params = params
	new_level.finished.connect(_on_level_finished)
	new_level.failed.connect(_on_level_failed)

	for child in world.get_children():
		world.remove_child(child)
	world.add_child(new_level)
	

func finish_level():
	var popup: PopupScreen = POPUP_SCREEN.instantiate()
	interface.add_child(popup)
	popup.button_pressed.connect(_on_button_pressed)
	popup.title.text = "Congratulations!"
	popup.text.text = "You completed\nprogram_%02d" % Globals.current_level
	popup.button.text = "Next"

	
func finish_screen():
	var popup: PopupScreen = POPUP_SCREEN.instantiate()
	interface.add_child(popup)
	popup.button_pressed.connect(start_game)
	popup.title.text = "Congratulations!"
	popup.text.text = "Thanks to your your job,\nno more memory leaks\nin any language!" 
	popup.button.text = "Restart"


func fail_screen():
	var popup: PopupScreen = POPUP_SCREEN.instantiate()
	interface.add_child(popup)
	popup.button_pressed.connect(start_game)
	popup.title.text = "You failed!"
	popup.text.text = "Thanks to your your job,\nwe have bad languages @xdk !" 
	popup.button.text = "Restart"


func _on_start_pressed():
	for child in interface.get_children():
		child.queue_free()
		
	next_level()


func _on_level_finished():
	finish_level()
	
	
func _on_button_pressed():
	for child in interface.get_children():
		child.queue_free()
	
	next_level()
	

func _on_level_failed():
	fail_screen()
