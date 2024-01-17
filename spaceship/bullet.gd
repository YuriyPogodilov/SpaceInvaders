class_name Bullet extends Area2D

@export_range(10, 3000, 10) var SPEED = 1000

func _physics_process(delta):
	position += Vector2.UP * SPEED * delta
	
	# Destroy if out of screen
	var view_port = get_viewport_rect()
	if (global_position.x < view_port.position.x || 
		global_position.x > view_port.end.x || 
		global_position.y < view_port.position.y ||
		global_position.y > view_port.end.y):
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
