extends CharacterBody2D

signal onEnemyKilled

var health = 2

func take_damage():
	health -= 1
	if health <= 0:
		die()
	

func die():
	# TODO: spawn explosion
	onEnemyKilled.emit()
	queue_free()
