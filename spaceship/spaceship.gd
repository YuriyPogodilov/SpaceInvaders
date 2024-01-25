class_name Spaceship extends CharacterBody2D

@export_range(50, 1000, 50) var SPEED = 350
@export_range(0.1, 3.0, 0.1) var SHOOTING_COOLDOWN = 0.5

signal onPlayerDied

var is_on_shooting_cooldown = false

func _physics_process(delta):
	var direction = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down")
	var direction_x = Vector2(direction.x, 0)
	velocity = direction_x * SPEED
	
	var view_port = get_viewport_rect()
	global_position = global_position.clamp(view_port.position, view_port.end)

	var collided = move_and_slide()
	if collided:
		var last_collision = get_last_slide_collision()
		var body = last_collision.get_collider()
		if body.is_in_group("Enemies"):
			body.destroy_by_collision()
			die()
	
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if is_on_shooting_cooldown:
		return

	is_on_shooting_cooldown = true
	%ShootingCooldown.start(SHOOTING_COOLDOWN)
	
	# TODO: spawn shooting effect
	SoundManager.play("res://sounds/laserShoot_0.wav")
	const BULLET = preload("res://spaceship/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_collision_mask_value(2, true)
	new_bullet.global_position = %ShootingPoint.global_position
	get_parent().add_child(new_bullet)

func _on_shooting_cooldown_timeout():
	is_on_shooting_cooldown = false

func die():
	# Spawn explosion
	const EXPLOSION = preload("res://explosion.tscn")
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.restart()

	SoundManager.play("res://sounds/explosion_2.wav")

	onPlayerDied.emit()
	queue_free()

func take_damage():
	# TODO: health
	die()
