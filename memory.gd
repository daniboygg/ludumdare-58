class_name Memory extends Node2D


@export var height := 10
@export var width := 40
@export var speed := 125.0
@export var deviation := speed * 0.2

@onready var color_rect: ColorRect = $ColorRect
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D



func _ready():
	speed = randf_range(speed - deviation, speed + deviation)
	color_rect.size.x = width
	collision_shape_2d.shape.size.x = width
	

func _process(delta: float) -> void:
	position.x = position.x + speed * delta
	
	if position.x > Globals.WIDTH:
		queue_free()
	
