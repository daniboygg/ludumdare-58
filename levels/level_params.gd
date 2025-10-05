class_name LevelParams
extends Resource

@export var corrupt_probability_evolution: Curve = null
@export var level_time_seconds: float = 0
@export var memory_span_every_seconds: float = 0

@export_group("Memory speed")
@export var memory_speed_min := 50.0
@export var memory_speed_max := 50.0

@export_group("Memory corrupted speed")
@export var memory_corrupted_speed_min := 50.0
@export var memory_corrupted_speed_max := 50.0

@export_group("Memory inc/dec")
@export var memory_increase := 5
@export var memory_decrease := 5
