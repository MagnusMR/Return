extends CharacterBody2D

@export var move_speed := 200.0
@export var roll_speed := 360.0
@export var roll_time := 0.25
@export var roll_cooldown := 0.35

var is_rolling := false
var roll_dir := Vector2.RIGHT
var last_dir := Vector2.RIGHT
var cd := 0.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	cd = max(cd - delta, 0.0)

	var dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	)

	if not is_rolling:
		if dir != Vector2.ZERO:
			dir = dir.normalized()
			last_dir = dir
			velocity = dir * move_speed
		else:
			velocity = Vector2.ZERO

		if Input.is_action_just_pressed("roll") and cd == 0.0:
			_start_roll(dir if dir != Vector2.ZERO else last_dir)
	else:
		velocity = roll_dir * roll_speed

	move_and_slide()
	_update_anim(dir)

func _update_anim(dir: Vector2) -> void:
	var facing := dir if dir != Vector2.ZERO else last_dir
	if is_rolling:
		_play("roll_" + _dir_suffix(facing))
	elif dir != Vector2.ZERO:
		_play("run_" + _dir_suffix(facing))
	else:
		_play("idle_" + _dir_suffix(facing))

func _dir_suffix(v: Vector2) -> String:
	if abs(v.x) >= abs(v.y):
		return "e" if v.x >= 0 else "w"
	else:
		return "s" if v.y >= 0 else "n"

func _start_roll(dir: Vector2) -> void:
	is_rolling = true
	roll_dir = dir
	cd = roll_cooldown
	_play("roll_" + _dir_suffix(dir))
	await get_tree().create_timer(roll_time).timeout
	is_rolling = false

func _play(name: String) -> void:
	if anim.animation != name:
		anim.play(name)
