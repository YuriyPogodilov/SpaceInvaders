class_name Ufo_1 extends CharacterBody2D

signal onEnemyKilled

var health = 2

func take_damage():
	health -= 1
	if health <= 0:
		die()

func die():
	# Spawn explosion
	const EXPLOSION = preload("res://explosion.tscn")
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.restart()

	onEnemyKilled.emit()
	queue_free()

func destroy_by_collision():
	die()
	
func shoot():
	# TODO: spawn shooting effect
	# TODO: play shooting sound
	const BULLET = preload("res://spaceship/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_collision_mask_value(1, true)
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.direction = Vector2.DOWN
	%ShootingPoint.add_child(new_bullet)
