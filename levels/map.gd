class_name Game extends Node2D

var score = 0

func _ready():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for E in enemies:
		E.connect("onEnemyKilled", increase_score)
		
	$Spaceship.connect("onPlayerDied", game_over)
	
func increase_score():
	score += 1
	%ScoreLabel.text = "%03d" % score

func game_over():
	%GameOverLabel.visible = true


func _on_enemies_attack_cooldown_timeout():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if not enemies.is_empty():
		var id = randi() % enemies.size()
		enemies[id].shoot()
