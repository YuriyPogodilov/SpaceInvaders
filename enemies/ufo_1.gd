class_name Ufo_1 extends CharacterBody2D

signal onEnemyKilled

@export_range(50, 1000, 50) var SPEED = 200

var health = 1
var is_attacking = false

func _physics_process(delta):
	if is_attacking:
		var direction = Vector2.UP.rotated(transform.get_rotation())
		position += direction * SPEED * delta
	var view_port = get_viewport_rect()
	if not view_port.has_point(position):
		position.x = clamp(position.x, view_port.position.x, view_port.end.x)
		position.y = 0

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

func attack(new_target: Vector2):
	look_at(new_target)
	rotation += PI / 2
	is_attacking = true
