extends "res://scripts/actor/actor.gd"

var player_chase = false
var player = null
var move_vector = Vector2.ZERO


func _ready() -> void:
	move_speed = 150


func get_move_vector():
	if player_chase:
		return (player.global_position - global_position).normalized()
	else:
		return Vector2.ZERO


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false
	print(player_chase)


func _physics_process(_delta) -> void:
	calculate_velocity()
	move_and_slide()
