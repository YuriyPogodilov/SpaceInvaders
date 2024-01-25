class_name Game extends Node2D

@export var enemies_attack_coodown: float = 3.0

var is_game_ended: bool = false
var score = 0

func _ready():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for E in enemies:
		E.connect("onEnemyKilled", increase_score)
	
	%Spaceship.connect("onPlayerDied", game_over)
	
	%EnemiesAttackCooldown.wait_time = enemies_attack_coodown
	%EnemiesAttackCooldown.autostart = true
	%EnemiesAttackCooldown.start()
	
func increase_score():
	score += 1
	%ScoreLabel.text = "%03d" % score
	
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies.size() == 1: # TODO: how to make it better?
		win()

func win():
	is_game_ended = true
	%GameEndInterface.visible = true
	%VictoryLabel.visible = true

func game_over():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for E in enemies:
		E.queue_free()
	
	is_game_ended = true
	%GameEndInterface.visible = true
	%GameOverLabel.visible = true

func _on_enemies_attack_cooldown_timeout():
	if is_game_ended:
		return

	var enemies = get_tree().get_nodes_in_group("Enemies")
	if not enemies.is_empty():
		var id = randi() % enemies.size()
		enemies[id].shoot()
		enemies[id].attack(%Spaceship)


func _on_restart_button_pressed():
	get_tree().reload_current_scene()
