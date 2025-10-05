class_name Memory extends Node2D

signal left_scene(Memory)
signal killed(Memory)

@onready var color_rect: ColorRect = $ColorRect
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

const color_good_base := Color("#346290")
const color_good_highlight := Color("4d8ccaff")
const color_bad_base := Color("#802e2e")
const color_bad_highlight := Color("cd3e3eff")

var color_base := color_good_base
var color_highlight := color_good_highlight

var height := 10
var width := 40
var speed := 20.0
var is_corrupt := false


func _ready():
	color_rect.size.x = width
	color_rect.color = color_base
	collision_shape_2d.shape.size.x = width
	

func _process(delta: float) -> void:
	position.x = position.x + speed * delta
	
	var mouse_position := get_viewport().get_mouse_position()
	var rect := Rect2(position, collision_shape_2d.shape.get_rect().size)
	if rect.has_point(mouse_position):
		color_rect.color = color_highlight
		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			killed.emit(self)
	else:
		color_rect.color = color_base
	
	if position.x > Globals.WIDTH:
		left_scene.emit(self)
		

func start_on_position(new_position: Vector2):
	position = new_position
	
	
func make_legit():
	color_base = color_good_base
	color_highlight = color_good_highlight
	is_corrupt = false
	
	
func make_corrupt():
	color_base = color_bad_base
	color_highlight = color_bad_highlight
	is_corrupt = true
	
	
