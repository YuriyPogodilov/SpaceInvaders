class_name Spacesheep extends CharacterBody2D

@export_range(50, 1000, 50) var SPEED = 350
@export_range(0.1, 3.0, 0.1) var SHOOTING_COOLDOWN = 0.5

var is_on_shooting_cooldown = false

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	var view_port = get_viewport_rect()
	global_position = global_position.clamp(view_port.position, view_port.end)

	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		shoot()


func shoot():
	if is_on_shooting_cooldown:
		return

	is_on_shooting_cooldown = true
	%ShootingCooldown.start(SHOOTING_COOLDOWN)
	
	const BULLET = preload("res://spaceship/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	%ShootingPoint.add_child(new_bullet)

func _on_shooting_cooldown_timeout():
	is_on_shooting_cooldown = false
