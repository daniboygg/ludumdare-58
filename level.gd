extends Node2D

@onready var timer: Timer = $Timer

const MEMORY := preload("uid://d36yllicrg8s1")

func _ready() -> void:
	pass

const TOP_MARGIN := 20
func create_memory_bar():
	var instance: Memory = MEMORY.instantiate()
	var start := Vector2(
		0 - instance.width, 
		randi_range(TOP_MARGIN, Globals.HEIGHT - instance.height),
	)
	instance.start_on_position(start)
	var bad_probability = randf()
	if bad_probability < 0.3:
		instance.make_corrupt()
		instance.speed = randf_range(100, 175)
	else:
		instance.make_legit()
		instance.speed = randf_range(50, 150)
	instance.left_scene.connect(_on_left_scene)
	instance.killed.connect(_on_killed)
	self.add_child(instance)


func _on_left_scene(memory: Memory):
	if memory.is_corrupt:
		Globals.increase_memory(20)
	else:
		Globals.decrease_memory(5)
	memory.queue_free()


func _on_killed(memory: Memory):
	if memory.is_corrupt:
		memory.queue_free()


func _on_timer_timeout() -> void:
	create_memory_bar()
	timer.wait_time = randf_range(0.2, 0.5)
	timer.start()
	
