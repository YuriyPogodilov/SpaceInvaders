extends CharacterBody2D

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
