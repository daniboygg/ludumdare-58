extends Control

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var label_2: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label2
@onready var percentage: Label = %Percentage


func _ready() -> void:
	Globals.memory_increased.connect(_on_memory_increased)


func _process(_delta: float) -> void:
	percentage.text = "%3d%%" % [Globals.memory]
	if OS.is_debug_build():
		label_2.text = "  c:%d%% t:%.0f" % [Globals.corrupt_probability*100, Globals.time_left]


func _on_memory_increased():
	texture_progress_bar.value = Globals.memory
