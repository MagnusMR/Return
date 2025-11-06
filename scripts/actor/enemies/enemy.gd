extends "res://scripts/actor/actor.gd"

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
var player_chase = false
var player = null
var move_vector = Vector2.ZERO
var attack_range = 40


func _on_detection_area_body_entered(body: Node2D):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false
	print(player_chase)


func get_move_vector() -> Vector2:
	if player_chase:
		navigation_agent.target_desired_distance = attack_range
		navigation_agent.set_target_position(player.global_position)
		var next_path_position = navigation_agent.get_next_path_position()
		move_vector = global_position.direction_to(next_path_position)
		if navigation_agent.is_navigation_finished():
			return Vector2.ZERO
		return move_vector
	else:
		return Vector2.ZERO


func handle_attack():
	if player_chase:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= attack_range && !is_attacking:
			is_attacking = true
			animated_sprite.play("attack_" + get_move_direction())
			print("attacking")


func _physics_process(_delta) -> void:
	handle_attack()
	calculate_velocity()
	move_and_slide()
