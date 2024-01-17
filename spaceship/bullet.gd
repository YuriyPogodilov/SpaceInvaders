class_name Bullet extends Area2D

@export_range(10, 3000, 10) var SPEED = 1000

func _physics_process(delta):
	position += Vector2.UP * SPEED * delta
	
	# Destroy if out of screen
	if global_position.y < -10:
		queue_free()



func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
