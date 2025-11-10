extends "res://scripts/actor/actor.gd"

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
var player_chase = false
var player = null
var attack_range = 40

@onready var timer: Timer = get_node("Timer")


func _ready() -> void:
	super ()
	navigation_agent.target_desired_distance = (attack_range - 20)
	timer.timeout.connect(_on_timer_timeout)


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	navigation_agent.set_target_position(player.global_position)
	timer.start()
	#print(player_chase)


func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false
	#print(player_chase)


func _on_timer_timeout():
	print("timer signal recived")
	if player_chase:
		navigation_agent.set_target_position(player.global_position)


func get_move_vector() -> Vector2:
	if player_chase:
		var next_path_position = navigation_agent.get_next_path_position()
		move_vector = global_position.direction_to(next_path_position)
		if navigation_agent.is_navigation_finished():
			return Vector2.ZERO
		return move_vector
	else:
		return Vector2.ZERO


func play_idle_animation() -> void:
	if move_vector:
		animated_sprite.play("idle_" + get_move_direction())


func play_run_animation():
	if move_vector != Vector2.ZERO:
		animated_sprite.play("run_" + get_move_direction())


func handle_attack():
	if player_chase:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= attack_range && !is_attacking:
			is_attacking = true
			animated_sprite.play("attack_" + get_move_direction())
			#print("attacking")


func _physics_process(_delta) -> void:
	get_move_direction()
	calculate_velocity()
	move_and_slide()
	handle_attack()
	if is_attacking:
		return
	play_idle_animation()
	play_run_animation()
