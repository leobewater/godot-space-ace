extends Node2D


func _ready():
	ScoreManager.reset_score()


func _process(delta):
	if Input.is_key_pressed(KEY_Q) == true:
		GameManager.load_main_scene()
		
	if Input.is_key_pressed(KEY_R) == true:
		ObjectMaker.create_power_up(Vector2(200, 200), GameData.POWERUP_TYPE.HEALTH)
