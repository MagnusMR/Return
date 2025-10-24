extends CharacterBody2D

@export var move_speed = 300

func get_input():
	return Input.get_vector("move_left","move_right","move_up","move_down")

func calculate_velocity():
	velocity = get_input() * move_speed
	
func _physics_process(delta):
	calculate_velocity()
	move_and_slide()
	
	
