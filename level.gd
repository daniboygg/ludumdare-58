extends Node2D

@export var curve: Curve

@onready var timer: Timer = $Timer
@onready var difficulty_checker_timer: Timer = $DifficultyCheckerTimer
@onready var level_timer: Timer = $LevelTimer

const MEMORY := preload("uid://d36yllicrg8s1")
const TOP_MARGIN := 20
const START_BAD_PROBABILITY := 0.3
var corrupt_probability := START_BAD_PROBABILITY

func _ready() -> void:
	Globals.corrupt_probability = START_BAD_PROBABILITY


func create_memory_bar():
	var instance: Memory = MEMORY.instantiate()
	var start := Vector2(
		0 - instance.width, 
		randi_range(TOP_MARGIN, Globals.HEIGHT - instance.height),
	)
	instance.start_on_position(start)
	var probability := randf()
	if probability < corrupt_probability:
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
		Globals.increase_memory(10)
	else:
		Globals.decrease_memory(2)
	memory.queue_free()


func _on_killed(memory: Memory):
	pass


func _on_timer_timeout() -> void:
	create_memory_bar()
	timer.wait_time = randf_range(0.2, 0.5)
	timer.start()
	

func _on_difficulty_timer_timeout() -> void:
	corrupt_probability = calculate_corruption_probability()
	Globals.corrupt_probability = corrupt_probability
	difficulty_checker_timer.start()


func calculate_corruption_probability() -> float:
	Globals.time_left = level_timer.time_left
	var x := (level_timer.wait_time - level_timer.time_left) / level_timer.wait_time
	assert(curve != null, "You must define a curve")
	return curve.sample(x)
