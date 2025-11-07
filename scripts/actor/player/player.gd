extends "res://scripts/actor/actor.gd"

var mouse_sector = 0


func _ready() -> void:
	super ()
	move_speed = 300


func get_move_vector() -> Vector2:
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#print(move_vector)
	return move_vector


func get_attack_input() -> bool:
	var attack_input = Input.is_action_just_pressed("attack")
	return attack_input


func get_block_input() -> bool:
	var block_input = Input.is_action_pressed("block")
	return block_input


# returns e, se, s....  as string, based on sector index of 0-7
func get_mouse_direction() -> String:
	var mouse_vector = ((get_global_mouse_position() - animated_sprite.global_position)).normalized()
	var mouse_angle = atan2(mouse_vector.y, mouse_vector.x)
	mouse_angle = fposmod(mouse_angle + PI / 8, TAU)
	mouse_sector = int(floor(mouse_angle / (PI / 4)))
	var mouse_direction = directions[mouse_sector]
	return mouse_direction


func handle_attack() -> void:
	if get_attack_input() && !is_attacking:
		is_attacking = true
		animated_sprite.play("attack_" + get_mouse_direction())


func handle_block() -> void:
	if get_block_input():
		is_blocking = true
		#print(is_blocking)
		animated_sprite.play("block_" + get_mouse_direction())
	else:
		is_blocking = false
		#print(is_blocking)


func play_idle_animation() -> void:
	if !get_move_vector():
		animated_sprite.play("idle_" + get_mouse_direction())


# function is named animation put also speed is adjusted. either neeeds to be renamed or seperated to 2 different functions
func play_run_animation() -> void:
	if get_move_vector():
		var difference = fposmod(move_sector - mouse_sector, 8)
		#print(difference)
		if difference <= 2 || difference >= 6:
			#print("running fowards")
			animated_sprite.play("run_forwards_" + get_move_direction())
			move_speed = 200
		else:
			animated_sprite.play("run_backwards_" + get_move_direction())
			move_speed = 150
			#print("playing backwards animation")


func update_state() -> void:
	if get_move_vector():
		last_vector = get_move_vector()
	handle_attack()
	if is_attacking:
		return
	handle_block()
	if is_blocking:
		return
	play_idle_animation()
	play_run_animation()


func _physics_process(_delta) -> void:
	get_move_vector()
	get_attack_input()
	get_mouse_direction()
	get_move_direction()
	calculate_velocity()
	update_state()
	move_and_slide()
