extends Node

var score = 0
var highest_score = 0

signal onScoreChanged(new_score: int)
signal onHighestScoreChanged(new_highest_score: int)

func _ready():
	# TODO: load highest score from a save file
	pass

func reset():
	score = 0

func get_score() -> int:
	return score

func get_highest_score() -> int:
	return highest_score

func add_score(add_score: int):
	score += add_score
	onScoreChanged.emit(score)
	
	if score > highest_score:
		highest_score = score
		onHighestScoreChanged.emit(highest_score)
