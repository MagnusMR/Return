extends CharacterBody2D

@export var move_speed = 300
@onready var _animated_sprite = $AnimatedSprite2D
var move_vector
var attack_input
var block_input
var last_vector = Vector2.RIGHT
var mouse_sector
var directions = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
var mouse_direction = 0
var is_attacking = false


func get_move_vector():
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return move_vector


func get_attack_input():
	attack_input = Input.is_action_just_pressed("attack")
	return attack_input


func get_block_input():
	block_input = Input.is_action_pressed("block")
	return block_input


func calculate_velocity():
	if !is_attacking:
		velocity = get_move_vector() * move_speed
	else:
		velocity = Vector2.ZERO


# returns sectors 0-7, corresponding to e, se, s.....
func get_mouse_sector():
	var mouse_vector = ((get_global_mouse_position() - _animated_sprite.global_position)).normalized()
	var mouse_angle = atan2(mouse_vector.y, mouse_vector.x)
	mouse_angle = fposmod(mouse_angle + PI / 8, TAU)
	mouse_sector = int(floor(mouse_angle / (PI / 4)))
	return mouse_sector


func attack_animation():
	if get_attack_input() && !is_attacking:
		is_attacking = true
		if last_vector.x > 0.8:
			_animated_sprite.play("attack_e")
		elif last_vector.x < 0.8 && last_vector.x > 0 && last_vector.y > 0:
			_animated_sprite.play("attack_se")
		elif last_vector.x == 0 && last_vector.y > 0.8:
			_animated_sprite.play("attack_s")
		elif last_vector.x < 0 && last_vector.x > -0.8 && last_vector.y > 0:
			_animated_sprite.play("attack_sw")
		elif last_vector.x < -0.8:
			_animated_sprite.play("attack_w")
		elif last_vector.x < 0 && last_vector.x > -0.8 && last_vector.y < 0:
			_animated_sprite.play("attack_nw")
		elif last_vector.x == 0 && last_vector.y < -0.8:
			_animated_sprite.play("attack_n")
		elif last_vector.x > 0 && last_vector.x < 0.8 && last_vector.y < 0:
			_animated_sprite.play("attack_ne")


func idle_animation():
	if !get_move_vector():
		if last_vector.x > 0.8:
			_animated_sprite.play("idle_e")
		elif last_vector.x < 0.8 && last_vector.x > 0 && last_vector.y > 0:
			_animated_sprite.play("idle_se")
		elif last_vector.x == 0 && last_vector.y > 0.8:
			_animated_sprite.play("idle_s")
		elif last_vector.x < 0 && last_vector.x > -0.8 && last_vector.y > 0:
			_animated_sprite.play("idle_sw")
		elif last_vector.x < -0.8:
			_animated_sprite.play("idle_w")
		elif last_vector.x < 0 && last_vector.x > -0.8 && last_vector.y < 0:
			_animated_sprite.play("idle_nw")
		elif last_vector.x == 0 && last_vector.y < -0.8:
			_animated_sprite.play("idle_n")
		elif last_vector.x > 0 && last_vector.x < 0.8 && last_vector.y < 0:
			_animated_sprite.play("idle_ne")


func run_animation():
	if get_move_vector().x > 0.8:
		_animated_sprite.play("run_e")
	elif get_move_vector().x < 0.8 && get_move_vector().x > 0 && get_move_vector().y > 0:
		_animated_sprite.play("run_se")
	elif get_move_vector().x == 0 && get_move_vector().y > 0.8:
		_animated_sprite.play("run_s")
	elif get_move_vector().x < 0 && get_move_vector().x > -0.8 && get_move_vector().y > 0:
		_animated_sprite.play("run_sw")
	elif get_move_vector().x < -0.8:
		_animated_sprite.play("run_w")
	elif get_move_vector().x < 0 && get_move_vector().x > -0.8 && get_move_vector().y < 0:
		_animated_sprite.play("run_nw")
	elif get_move_vector().x == 0 && get_move_vector().y < -0.8:
		_animated_sprite.play("run_n")
	elif get_move_vector().x > 0 && get_move_vector().x < 0.8 && get_move_vector().y < 0:
		_animated_sprite.play("run_ne")


func update_animation():
	if get_move_vector():
		last_vector = get_move_vector()
	attack_animation()
	if is_attacking:
		print("is attacking")
		return
	idle_animation()
	run_animation()


func animation_done() -> void:
	print("signal received")
	if _animated_sprite.animation.begins_with("attack"):
		is_attacking = false


func _physics_process(_delta):
	get_move_vector()
	get_mouse_sector()
	calculate_velocity()
	update_animation()
	move_and_slide()
