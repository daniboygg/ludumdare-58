class_name PopupScreen
extends Control

signal button_pressed

@onready var title: Label = %Title
@onready var text: Label = %Text
@onready var button: Button = %Button

@onready var panel_container: PanelContainer = %PanelContainer
@onready var bg_rect: ColorRect = %BGRect

var final_pos := Vector2.ZERO

func _ready() -> void:
	final_pos = panel_container.position
	animate_in()


func animate_in():
	panel_container.modulate = Color.TRANSPARENT
	panel_container.position = panel_container.position - Vector2(0, Globals.HEIGHT)
	panel_container.modulate = Color.WHITE
	bg_rect.modulate.a = 0
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel_container, "position", final_pos, 0.3)
	tween.tween_property(bg_rect, "modulate:a", 0.6, 0.3)


func animate_out():
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(panel_container, "position", panel_container.position - Vector2(0, Globals.HEIGHT), 0.3)
	tween.tween_property(bg_rect, "modulate:a", 0, 0.3)
	tween.chain().tween_callback(func(): button_pressed.emit())


func _on_button_pressed() -> void:
	animate_out()
	
