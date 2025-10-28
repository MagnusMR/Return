extends CharacterBody2D

@export var move_speed = 300
@onready var animated_sprite = $AnimatedSprite2D
var last_vector = Vector2.RIGHT
var move_sector = 0
var last_move_sector = 0
var mouse_sector = 0
var directions = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
var is_attacking = false


func get_move_vector() -> Vector2:
	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return move_vector


func get_attack_input() -> bool:
	var attack_input = Input.is_action_just_pressed("attack")
	return attack_input


func get_block_input() -> bool:
	var block_input = Input.is_action_pressed("block")
	return block_input


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


# returns e, se, s....  as string, based on sector index of 0-7
func get_mouse_direction() -> String:
	var mouse_vector = ((get_global_mouse_position() - animated_sprite.global_position)).normalized()
	var mouse_angle = atan2(mouse_vector.y, mouse_vector.x)
	mouse_angle = fposmod(mouse_angle + PI / 8, TAU)
	mouse_sector = int(floor(mouse_angle / (PI / 4)))
	var mouse_direction = directions[mouse_sector]
	return mouse_direction


func calculate_velocity() -> void:
	if !is_attacking:
		velocity = get_move_vector() * move_speed
	else:
		velocity = Vector2.ZERO


func attack_animation() -> void:
	if get_attack_input() && !is_attacking:
		is_attacking = true
		animated_sprite.play("attack_" + get_mouse_direction())


func idle_animation() -> void:
	if !get_move_vector():
		animated_sprite.play("idle_" + get_mouse_direction())


# function is named animation put also speed is adjusted. either neeeds to be renamed or seperated to 2 different functions
func run_direction() -> void:
	var difference = fposmod(move_sector - mouse_sector, 8)
	print(difference)
	if difference == 0:
		animated_sprite.play("run_forwards_" + get_move_direction())
		move_speed = 300
	elif difference == 2:
		animated_sprite.play("run_sideways_right_" + get_move_direction())
		move_speed = 250
	elif difference == 4:
		animated_sprite.play("run_backwards_" + get_move_direction())
		move_speed = 200
		print("playing backwards animation")
	elif difference == 6:
		animated_sprite.play("run_sideways_left_" + get_move_direction())
		move_speed = 250


func update_animation() -> void:
	if get_move_vector():
		last_vector = get_move_vector()
	attack_animation()
	if is_attacking:
		print("is attacking")
		return
	idle_animation()
	run_direction()


func animation_done() -> void:
	print("signal received")
	if animated_sprite.animation.begins_with("attack"):
		is_attacking = false


func _physics_process(_delta) -> void:
	get_move_vector()
	get_attack_input()
	get_mouse_direction()
	get_move_direction()
	calculate_velocity()
	update_animation()
	move_and_slide()
