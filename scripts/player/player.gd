extends CharacterBody2D

@export var move_speed = 300
@onready var _animated_sprite = $AnimatedSprite2D
var input_state
var last_vector = Vector2.RIGHT
var is_attacking = false


func get_input():
	input_state = {
		"move_vector": Input.get_vector("move_left", "move_right", "move_up", "move_down"),
		"attack": Input.is_action_just_pressed("attack"),
		"block": Input.is_action_pressed("block"),
		"roll": Input.is_action_pressed("roll"),
	}
	return input_state


func calculate_velocity():
	if !is_attacking:
		velocity = input_state["move_vector"] * move_speed
	else:
		velocity = Vector2.ZERO


func attack_animation():
	if input_state["attack"] && !is_attacking:
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
	if !input_state["move_vector"]:
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
	if input_state["move_vector"].x > 0.8:
		_animated_sprite.play("run_e")
	elif input_state["move_vector"].x < 0.8 && input_state["move_vector"].x > 0 && input_state["move_vector"].y > 0:
		_animated_sprite.play("run_se")
	elif input_state["move_vector"].x == 0 && input_state["move_vector"].y > 0.8:
		_animated_sprite.play("run_s")
	elif input_state["move_vector"].x < 0 && input_state["move_vector"].x > -0.8 && input_state["move_vector"].y > 0:
		_animated_sprite.play("run_sw")
	elif input_state["move_vector"].x < -0.8:
		_animated_sprite.play("run_w")
	elif input_state["move_vector"].x < 0 && input_state["move_vector"].x > -0.8 && input_state["move_vector"].y < 0:
		_animated_sprite.play("run_nw")
	elif input_state["move_vector"].x == 0 && input_state["move_vector"].y < -0.8:
		_animated_sprite.play("run_n")
	elif input_state["move_vector"].x > 0 && input_state["move_vector"].x < 0.8 && input_state["move_vector"].y < 0:
		_animated_sprite.play("run_ne")


func update_animation():
	if input_state["move_vector"]:
		last_vector = input_state["move_vector"]
	attack_animation()
	if is_attacking:
		print("is attacking")
		return
	idle_animation()
	run_animation()


func _physics_process(_delta):
	get_input()
	calculate_velocity()
	update_animation()
	move_and_slide()


func animation_done() -> void:
	print("signal received")
	if _animated_sprite.animation.begins_with("attack"):
		is_attacking = false
