class_name Ufo_1 extends CharacterBody2D

signal onEnemyKilled

@export_range(50, 1000, 50) var SPEED = 200
@export_range(50, 1000, 50) var SPEED_STEP = 50

var health = 1
var is_moving = false
var is_attacking = false
var destination: Vector2 = Vector2.ZERO
var target: Node2D = null

func _ready():
	var anim_speed: float = randf() + 0.5
	var from_end: bool = randi() % 2
	$AnimationPlayer.play("idle", -1, anim_speed, from_end)

func _physics_process(delta):
	if is_moving && destination != Vector2.ZERO:
		if global_position != destination:
			global_position = global_position.move_toward(destination, get_speed() * delta)
		else:
			is_moving = false
	elif is_attacking && target != null:
		global_position.y += get_speed() * delta
		global_position.x = lerp(global_position.x, target.global_position.x, 0.01 * GameMode.get_difficulty())

	# Respawn at the top after reaching the bottom of the screen
	var view_port = get_viewport_rect()
	if global_position.y > view_port.end.y + 50:
		position.y = 0


func get_speed() -> float:
	return SPEED + SPEED_STEP * GameMode.get_difficulty()


func move_to(new_destination: Vector2):
	destination = new_destination
	is_moving = true


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
	if is_moving:
		return
	$AnimationPlayer.stop()
	target = new_target
	is_attacking = true
