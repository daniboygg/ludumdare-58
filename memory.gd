class_name Memory extends Node2D


@export var height := 10
@export var width := 40
@export var speed := 20.0
@export var deviation := speed * 0.2

@onready var color_rect: ColorRect = $ColorRect
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var label: Label = $Label

const color_base := Color("#2d5e91")
const color_highlight := Color("#5e9ee0ff")

func _ready():
	speed = randf_range(speed - deviation, speed + deviation)
	color_rect.size.x = width
	color_rect.color = color_base
	collision_shape_2d.shape.size.x = width
	

func _process(delta: float) -> void:
	position.x = position.x + speed * delta
	
	var mouse_position := get_viewport().get_mouse_position()
	var rect := Rect2(position, collision_shape_2d.shape.get_rect().size)
	if rect.has_point(mouse_position):
		color_rect.color = color_highlight
	else:
		color_rect.color = color_base
	
	if position.x > Globals.WIDTH:
		queue_free()
	
