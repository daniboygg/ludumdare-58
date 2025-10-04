extends Node2D

@onready var timer: Timer = $Timer

const MEMORY := preload("uid://d36yllicrg8s1")

func _ready() -> void:
	pass

	
func create_memory_bar():
	var instance: Memory = MEMORY.instantiate()
	var start := Vector2(
		0 - instance.width, 
		randi_range(0, Globals.HEIGHT - instance.height),
	)
	instance.start_on_position(start)
	var bad_probability = randf()
	if bad_probability < 0.3:
		instance.make_corrupt()
		instance.speed = randf_range(100, 175)
	else:
		instance.make_legit()
		instance.speed = randf_range(50, 150)
	
	self.add_child(instance)


func _on_timer_timeout() -> void:
	create_memory_bar()
	timer.wait_time = randf_range(0.2, 0.5)
	timer.start()
	
