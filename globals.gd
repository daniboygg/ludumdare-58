extends Node

signal memory_increased

const WIDTH := 320
const HEIGHT := 180

var memory := 0
var rage := 0

var corrupt_probability := 0.0
var time_left := 0.0


func increase_memory(amount: int = 5):
	memory = min(100, memory + amount)
	memory_increased.emit()
	

func decrease_memory(amount: int = 5):
	memory = max(0, memory - amount)
	memory_increased.emit()
