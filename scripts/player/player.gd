extends CharacterBody2D

@export var move_speed = 300
@onready var _animated_sprite = $AnimatedSprite2D
var move_vector
var last_vector = Vector2.RIGHT


func get_input():
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return move_vector


func calculate_velocity():
	velocity = get_input() * move_speed


func idle_animation():
	if !move_vector:
		if last_vector.x > 0.8:
			_animated_sprite.play("idle_e")
		elif last_vector.x < 0.8 && last_vector.x > 0 && last_vector.y > 0:
			_animated_sprite.play("idle_se")
		elif last_vector.x == 0 && last_vector.y > 0.8:
			_animated_sprite.play("idle_s")
		elif last_vector.x < 0 and last_vector.x > -0.8 and last_vector.y > 0:
			_animated_sprite.play("idle_sw")
		elif last_vector.x < -0.8:
			_animated_sprite.play("idle_w")
		elif last_vector.x < 0 and last_vector.x > -0.8 and last_vector.y < 0:
			_animated_sprite.play("idle_nw")
		elif last_vector.x == 0 and last_vector.y < -0.8:
			_animated_sprite.play("idle_n")
		elif last_vector.x > 0 and last_vector.x < 0.8 and last_vector.y < 0:
			_animated_sprite.play("idle_ne")


func run_animation():
	if move_vector.x > 0.8:
		_animated_sprite.play("run_e")
	elif move_vector.x < 0.8 && move_vector.x > 0 && move_vector.y > 0:
		_animated_sprite.play("run_se")
	elif move_vector.x == 0 && move_vector.y > 0.8:
		_animated_sprite.play("run_s")
	elif move_vector.x < 0 and move_vector.x > -0.8 and move_vector.y > 0:
		_animated_sprite.play("run_sw")
	elif move_vector.x < -0.8:
		_animated_sprite.play("run_w")
	elif move_vector.x < 0 and move_vector.x > -0.8 and move_vector.y < 0:
		_animated_sprite.play("run_nw")
	elif move_vector.x == 0 and move_vector.y < -0.8:
		_animated_sprite.play("run_n")
	elif move_vector.x > 0 and move_vector.x < 0.8 and move_vector.y < 0:
		_animated_sprite.play("run_ne")


func update_animation():
	if move_vector:
		last_vector = move_vector
	idle_animation()
	run_animation()


func _physics_process(_delta):
	calculate_velocity()
	update_animation()
	move_and_slide()
