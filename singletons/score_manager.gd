extends Node


var _score: int = 0
var _high_score: int = 0


func get_score() -> int:
	return _score


func get_high_score() -> int:
	return _high_score


func increment_score(v: int) -> void:
	_score += v
	if _high_score < _score:
		_high_score = _score
	SignalManager.on_score_updated.emit(_score)
	
	
func reset_score() -> void:
	_score = 0
	SignalManager.on_score_updated.emit(_score)


# TODO: save to json file like previous exercise
