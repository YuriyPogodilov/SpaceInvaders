extends CharacterBody2D

var health = 2

func take_damage():
	health -= 1
	if health <= 0:
		queue_free()
	
