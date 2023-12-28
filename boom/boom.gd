extends AnimatedSprite2D


@onready var sound = $Sound


func _ready():
	SoundManager.play_explosion_random(sound)


# remove self after finished playing animation
func _on_animation_finished():
	queue_free()
