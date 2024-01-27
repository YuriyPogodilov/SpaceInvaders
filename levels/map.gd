class_name Game extends Node2D

@export var enemies_attack_coodown: float = 3.0

var is_game_ended: bool = false

func _ready():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for E in enemies:
		E.connect("onEnemyKilled", func(): GameMode.add_score(1))
	
	%Spaceship.connect("onPlayerDied", game_over)
	
	%EnemiesAttackCooldown.wait_time = enemies_attack_coodown
	%EnemiesAttackCooldown.autostart = true
	%EnemiesAttackCooldown.start()
	
	%RestartButton.connect("pressed", restart)

	%ScoreLabel.text = "Score: %03d" % GameMode.get_score()
	%HighestScoreLabel.text = "Highest: %03d" % GameMode.get_highest_score()
	
	GameMode.connect("onScoreChanged", func(new_score: int): %ScoreLabel.text = "Score: %03d" % new_score)
	GameMode.connect("onHighestScoreChanged", func(new_score: int): %HighestScoreLabel.text = "Highest: %03d" % new_score)

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		if is_game_ended:
			restart()

func game_over():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for E in enemies:
		E.queue_free()
	
	is_game_ended = true
	%GameOverInterface.visible = true

func restart():
	get_tree().reload_current_scene()
	GameMode.reset()

func respawn_enemies():
	pass

func _on_enemies_attack_cooldown_timeout():
	if is_game_ended:
		return

	var enemies = get_tree().get_nodes_in_group("Enemies")
	if not enemies.is_empty():
		var id = randi() % enemies.size()
		enemies[id].shoot()
		enemies[id].attack(%Spaceship)

func _on_child_exiting_tree(node):
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies.is_empty():
		respawn_enemies()
