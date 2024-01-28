class_name Ufo_1 extends CharacterBody2D

signal onEnemyKilled

@export_range(50, 1000, 50) var SPEED = 50

var health = 1
var is_attacking = false
var attacking_time = 0
var attack_duration = 2.5
var attack_curve_points: Array[Vector2]

var target: Node2D = null

func _ready():
	var anim_speed: float = randf() + 0.5
	var from_end: bool = randi() % 2
	$AnimationPlayer.play("idle", -1, anim_speed, from_end)

func _physics_process(delta):
	if is_attacking && target != null:
		var difficulty = GameMode.get_difficulty()
		global_position.y += SPEED * difficulty * delta
		global_position.x = lerp(global_position.x, target.global_position.x, 0.01 * difficulty)

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
	const EXPLOSION_EFFECT = preload("res://explosion.tscn")
	var explosion_effect = EXPLOSION_EFFECT.instantiate()
	get_parent().add_child(explosion_effect)
	explosion_effect.global_position = global_position
	explosion_effect.restart()
	
	SoundManager.play("res://sounds/explosion_0.wav")

	onEnemyKilled.emit()
	queue_free()

func destroy_by_collision():
	die()
	
func shoot():
	# TODO: spawn shooting effect
	SoundManager.play("res://sounds/laserShoot_1.wav")
	const BULLET = preload("res://spaceship/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_collision_mask_value(1, true)
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.direction = Vector2.DOWN
	get_parent().add_child(new_bullet)

func attack(new_target: Node2D):
	$AnimationPlayer.stop()
	target = new_target
	is_attacking = true
