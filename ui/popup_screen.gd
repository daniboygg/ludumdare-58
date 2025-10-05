class_name PopupScreen
extends Control

signal button_pressed

@onready var title: Label = %Title
@onready var text: Label = %Text
@onready var button: Button = %Button


func _on_button_pressed() -> void:
	button_pressed.emit()
