class_name Ufo_1 extends CharacterBody2D

signal onEnemyKilled

@export_range(50, 1000, 50) var SPEED = 200

var health = 1
var is_attacking = false
var attacking_time = 0
var attack_duration = 2.5
var attack_curve_points: Array[Vector2]

func _physics_process(delta):
	if is_attacking:
		if attacking_time < attack_duration:
			var t = attacking_time / attack_duration
			global_position = cubic_bezier(t, attack_curve_points)
			attacking_time += delta
		else:
			var direction = Vector2.UP.rotated(transform.get_rotation())
			position += direction * SPEED * delta

	# Respawn at the top after reaching the bottom of the screen
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
	
	# Init attack curve
	attack_curve_points.clear()
	var point0 = global_position
	attack_curve_points.push_back(point0)
	var point1 = global_position
	point1.y -= 100
	attack_curve_points.push_back(point1)
	var point2 = point1
	var direction = -1 * randi() % 2
	if direction == 0:
		direction = 1
	point2.x += direction * 300
	attack_curve_points.push_back(point2)
	var point3 = new_target
	attack_curve_points.push_back(point3)
	
	is_attacking = true

func factorial(n: int) -> int:
	if n == 1 || n == 0:
		return 1
	else:
		return n * factorial(n - 1)

func binominal_koef(n: int, k: int) -> int:
	return factorial(n) / (factorial(k) * factorial(n - k))

func bezier(t: float, points: Array[Vector2]) -> Vector2:
	var result = Vector2.ZERO
	var n = points.size()
	for i in range(n):
		result += binominal_koef(n, i) * pow(1 - t, n - i) * pow(t, i) * points[i]
	return result

func cubic_bezier(t: float, points: Array[Vector2]) -> Vector2:
	assert(points.size() == 4)
	var result = pow(1-t, 3)*points[0] + 3*pow(1-t, 2)*t*points[1] + 3*(1-t)*pow(t, 2)*points[2] + pow(t, 3)*points[3]
	return result
