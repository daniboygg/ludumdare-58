class_name Level
extends Node2D

signal finished
signal failed

@export var params: LevelParams

@onready var span_memory_timer: Timer = $SpanMemoryTimer
@onready var difficulty_checker_timer: Timer = $DifficultyCheckerTimer
@onready var level_timer: Timer = $LevelTimer
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var memory_full_timer: Timer = $MemoryFullTimer

const MEMORY := preload("uid://d36yllicrg8s1")
const TOP_MARGIN := 20

var is_finished := false

func _ready() -> void:
	span_memory_timer.wait_time = params.memory_span_every_seconds
	level_timer.wait_time = params.level_time_seconds
	level_timer.start()
	memory_full_timer.wait_time = params.grace_period_seconds
	calculate_corruption_probability()


func calculate_corruption_probability() -> void:
	Globals.set_time(level_timer.time_left, params)
	var x := (level_timer.wait_time - level_timer.time_left) / level_timer.wait_time
	var probability = params.corrupt_probability_evolution.sample(x)
	Globals.corrupt_probability = probability
	

func create_memory_bar():
	var instance: Memory = MEMORY.instantiate()
	var start := Vector2(
		0 - instance.width, 
		randi_range(TOP_MARGIN, Globals.HEIGHT - instance.height),
	)
	instance.start_on_position(start)
	var probability := randf()
	if probability < Globals.corrupt_probability:
		instance.make_corrupt()
		instance.speed = randf_range(
			params.memory_corrupted_speed_min, 
			params.memory_corrupted_speed_max,
		)
	else:
		instance.make_legit()
		instance.speed = randf_range(
			params.memory_speed_min, 
			params.memory_speed_max,
		)
	instance.left_scene.connect(_on_left_scene)
	instance.killed.connect(_on_killed)
	self.add_child(instance)


func _on_left_scene(memory: Memory):
	if is_finished:
		return
		
	if memory.is_corrupt:
		Globals.increase_memory(params.memory_increase)
	else:
		if memory_full_timer.is_stopped():
			# do not decrease while user is full
			# force the user to take action
			Globals.decrease_memory(params.memory_decrease)
	
	if Globals.memory >= 100:
		if memory_full_timer.is_stopped():
			memory_full_timer.start()
	elif not memory_full_timer.is_stopped():
		memory_full_timer.stop()


func _on_killed(memory: Memory):
	pass


func _on_timer_timeout() -> void:
	create_memory_bar()
	span_memory_timer.start()
	

func _on_difficulty_timer_timeout() -> void:
	calculate_corruption_probability()
	difficulty_checker_timer.start()


func _on_level_timer_timeout() -> void:
	difficulty_checker_timer.stop()
	memory_full_timer.stop()
	Globals.corrupt_probability = 0
	is_finished = true
	finished.emit()


func _on_memory_full_timer_timeout() -> void:
	is_finished = true
	difficulty_checker_timer.stop()
	memory_full_timer.stop()
	level_timer.stop()
	failed.emit()
