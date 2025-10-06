class_name StartScreen
extends Control

signal start_pressed
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_button_pressed() -> void:
	audio_stream_player.play()
	await audio_stream_player.finished
	start_pressed.emit()	
