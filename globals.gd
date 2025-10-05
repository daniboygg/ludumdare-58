extends Node

signal memory_increased

const WIDTH := 360
const HEIGHT := 180

var memory := 0
var rage := 0


func increase_memory(amount: int = 5):
	memory += amount
	memory_increased.emit()
	

func decrease_memory(amount: int = 5):
	memory -= amount
	memory_increased.emit()
