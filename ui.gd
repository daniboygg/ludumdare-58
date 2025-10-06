extends Control

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var percentage: Label = %Percentage
@onready var clock: TextureProgressBar = %Clock
@onready var program: Label = %Program
@onready var debug: Label = %Debug

const green := Color("609034ff")
const orange := Color("9b5f36ff")
const red := Color("802e2eff")

var tween_grace: Tween = null

func _ready() -> void:
	Globals.memory_increased.connect(_on_memory_increased)
	texture_progress_bar.value = Globals.memory


func _process(_delta: float) -> void:
	if Globals.memory < 70:
		texture_progress_bar.modulate = green
		percentage.modulate = green
	elif Globals.memory < 90:
		texture_progress_bar.modulate = orange
		percentage.modulate = orange
	else:
		texture_progress_bar.modulate = red
		percentage.modulate = red

	percentage.text = "%3d%%" % [Globals.memory]
	clock.value = Globals.time_normalized * 100
	program.text = "program_%02d" % Globals.current_level
	
	if OS.is_debug_build():
		debug.text = "  c:%d%% t:%.0f" % [Globals.corrupt_probability*100, Globals.time_left]


func _on_memory_increased():
	texture_progress_bar.value = Globals.memory
