extends Node

const SAVE_FILE_PATH = "user://SpaceInvaders.save"

var score: int = 0: get = get_score
var highest_score: int = 0: get = get_highest_score
var difficulty: int = 1: get = get_difficulty

signal onScoreChanged(new_score: int)
signal onHighestScoreChanged(new_highest_score: int)
signal onDifficultyChanged(new_difficulty: int)

func _ready():
	load_game()


func reset():
	score = 0
	difficulty = 1


func get_score() -> int:
	return score


func get_highest_score() -> int:
	return highest_score


func add_score(points_to_add: int):
	score += points_to_add
	onScoreChanged.emit(score)
	
	if score > highest_score:
		highest_score = score
		onHighestScoreChanged.emit(highest_score)


func get_difficulty() -> int:
	return difficulty


func increase_difficulty():
	difficulty += 1
	onDifficultyChanged.emit(difficulty)

 
func save_data():
	var save_dict = {
		"highest_score" : get_highest_score()
	}
	return save_dict


func save_game():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data())
	save_file.store_line(json_string)


func load_game():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)

	var json_string = save_file.get_line()
	var json = JSON.new()
	
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	
	var node_data = json.get_data()
	highest_score = node_data["highest_score"]
