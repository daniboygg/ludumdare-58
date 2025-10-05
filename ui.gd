extends Control

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar


func _ready() -> void:
	Globals.memory_increased.connect(_on_memory_increased)


func _on_memory_increased():
	texture_progress_bar.value = Globals.memory
