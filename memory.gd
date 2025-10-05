class_name Memory extends Node2D

signal left_scene(Memory)
signal killed(Memory)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $Node2D/ColorRect
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

const LEAK = preload("uid://b3sm4kevlnyh2")
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
var is_killed := false


func _ready():
	color_rect.size.x = width
	color_rect.color = color_base
	collision_shape_2d.shape.size.x = width
	

func _process(delta: float) -> void:
	position.x = position.x + speed * delta
	
	if is_killed:
		return
	
	if is_mouse_over_me():
		color_rect.color = color_highlight
	else:
		color_rect.color = color_base
	
	if position.x > Globals.WIDTH:
		left_scene.emit(self)
		if is_corrupt:
			is_killed = true
			left_scene.emit(self)
			show_leak_level_and_free()
		else:
			queue_free()
			

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or is_killed:
		return
		
	if event.is_released() and is_mouse_over_me() and is_corrupt:
		is_killed = true
		animation_player.play("killed")
		killed.emit(self)


func is_mouse_over_me() -> bool:
	var mouse_position := get_viewport().get_mouse_position()
	var rect := Rect2(position, collision_shape_2d.shape.get_rect().size)
	return rect.has_point(mouse_position)
	

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
	

func show_leak_level_and_free():
	var leak: Leak = LEAK.instantiate()
	leak.position = position - Vector2(24, 0) # 24 label width
	var parent = get_parent()
	parent.add_child(leak)
	leak.animation_player.play("default")
	leak.animation_player.animation_finished.connect(_on_leak_animation_finished)

	
func _on_leak_animation_finished(_name: String):
	queue_free()
