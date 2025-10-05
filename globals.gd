extends Node

signal memory_increased

const WIDTH := 320
const HEIGHT := 180

var memory := 0
var rage := 0

var corrupt_probability := 0.0
var time_left := 0.0  
var time_normalized := 0.0 # between 0 and 1
var level_time := 0.0


func set_time(time: float, level_params: LevelParams):
	time_left = time
	time_normalized = remap(time, level_params.level_time_seconds, 0, 0, 1)


func increase_memory(amount: int = 5):
	memory = min(100, memory + amount)
	memory_increased.emit()
	

func decrease_memory(amount: int = 5):
	memory = max(0, memory - amount)
	memory_increased.emit()
