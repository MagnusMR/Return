extends CharacterBody2D

var move_speed = 150
var is_attacking = false
var is_blocking = false
var directions = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
var last_vector = Vector2.RIGHT
var move_sector = 0
var last_move_sector = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.animation_finished.connect(animation_done)
	print("signal connected")


func animation_done():
	print("signal received")
	if animated_sprite.animation.begins_with("attack"):
		is_attacking = false


func get_move_direction() -> String:
	if get_move_vector().length_squared() > 0:
		var move_angle = atan2(get_move_vector().y, get_move_vector().x)
		move_angle = fposmod(move_angle + PI / 8, TAU)
		move_sector = int(floor(move_angle / (PI / 4)))
		last_move_sector = move_sector
	else:
		move_sector = last_move_sector
	var move_direction = directions[move_sector]
	return move_direction


func get_move_vector():
	pass


func calculate_velocity() -> void:
	if !is_attacking && !is_blocking:
		velocity = get_move_vector() * move_speed
	else:
		velocity = Vector2.ZERO
