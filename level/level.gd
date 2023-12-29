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
	
	# when game over, explode all nodes and remove them
	for node in get_children():
		if is_instance_valid(node) and node.is_class("Node2D"):
			ObjectMaker.create_explosion(node.global_position, self)
			node.queue_free()
