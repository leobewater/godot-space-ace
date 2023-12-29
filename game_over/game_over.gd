extends Control

@onready var score_label = $ColorRect/VB/ScoreLabel
@onready var timer = $Timer


var _can_shoot: bool = false


func _ready():
	hide()
	SignalManager.on_player_died.connect(on_player_died)


func _process(delta):
	if _can_shoot and Input.is_action_just_pressed("shoot"):
		GameManager.load_main_scene()


func on_player_died() -> void:
	show()
	timer.start()
	score_label.text = "Score: %s (Best: %s)" % [
		ScoreManager.get_score(),
		ScoreManager.get_high_score(),
	]


func _on_timer_timeout():
	_can_shoot = true
