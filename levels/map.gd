class_name Game extends Node2D

@export var attack_cooldown_min: float = 2.0
@export var attack_cooldown_max: float = 4.0

var is_game_ended: bool = false

func _ready():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for E in enemies:
		E.connect("onEnemyKilled", func(): GameMode.add_score(1))
	
	%Spaceship.connect("onPlayerDied", game_over)
	
	%EnemiesAttackCooldown.autostart = false
	%EnemiesAttackCooldown.start(randf_range(attack_cooldown_min, attack_cooldown_max))
	
	%RestartButton.connect("pressed", restart)

	%ScoreLabel.text = "Score: %03d" % GameMode.get_score()
	%HighestScoreLabel.text = "Highest: %03d" % GameMode.get_highest_score()
	%Wave.text = "Wave: %d" % GameMode.get_difficulty()
	
	GameMode.connect("onScoreChanged", func(new_score: int): %ScoreLabel.text = "Score: %03d" % new_score)
	GameMode.connect("onHighestScoreChanged", func(new_score: int): %HighestScoreLabel.text = "Highest: %03d" % new_score)
	GameMode.connect("onDifficultyChanged", func(new_difficulty: int): %Wave.text = "Wave: %d" % new_difficulty)

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		restart()

func game_over():
	GameMode.save_game()
	
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for E in enemies:
		E.queue_free()
	
	is_game_ended = true
	%GameOverInterface.visible = true

func restart():
	if is_game_ended:
		get_tree().reload_current_scene()
		GameMode.reset()

func respawn_enemies():
	if not is_game_ended:
		GameMode.increase_difficulty()
		get_tree().reload_current_scene()

func _on_enemies_attack_cooldown_timeout():
	if is_game_ended:
		return

	var enemies = get_tree().get_nodes_in_group("Enemies")
	if not enemies.is_empty():
		var id = randi() % enemies.size()
		enemies[id].shoot()
		enemies[id].attack(%Spaceship)
	
	%EnemiesAttackCooldown.start(randf_range(attack_cooldown_min, attack_cooldown_max))


func _on_child_exiting_tree(_node):
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if enemies.is_empty():
		respawn_enemies()
