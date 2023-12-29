extends Node2D


@onready var sound = $Sound


func _ready():
	ScoreManager.reset_score()
	SignalManager.on_player_died.connect(on_player_died)


func _process(delta):
	if Input.is_key_pressed(KEY_Q) == true:
		GameManager.load_main_scene()
		

# stop music when player died
func on_player_died() -> void:
	sound.stop()
