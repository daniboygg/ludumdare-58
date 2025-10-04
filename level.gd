extends Node2D

@onready var timer: Timer = $Timer

const MEMORY := preload("uid://d36yllicrg8s1")
const MIN_TIME := 1
const MAX_TIME := 2

func _ready() -> void:
	timer.wait_time = randf_range(MIN_TIME, MAX_TIME)
	timer.start()


func _process(delta: float) -> void:
	pass
	
	
func create_memory_bar():
	var instance: Memory = MEMORY.instantiate()
	instance.position.x = 0 - instance.width
	instance.position.y = randi_range(0, Globals.HEIGHT - instance.height)
	self.add_child(instance)


func _on_timer_timeout() -> void:
	create_memory_bar()
	timer.wait_time = randf_range(MIN_TIME, MAX_TIME)
	timer.start()
	
