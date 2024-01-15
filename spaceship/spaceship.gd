class_name Spacesheep extends CharacterBody2D

@export_range(50, 1000, 50) var SPEED = 600

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	var view_port = get_viewport_rect()
	global_position = global_position.clamp(view_port.position, view_port.end)

	move_and_slide()
