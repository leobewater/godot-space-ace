extends Area2D


var _direction: Vector2 = Vector2.UP
var _speed: float = 200.0
var _damage: int = 10


func _ready():
	pass


func _process(delta):
	position += _direction * _speed * delta
	
	
func setup(pos: Vector2, dir: Vector2, sp: float, dmg: int) -> void:
	_direction = dir
	_speed = sp
	_damage = dmg
	global_position = pos


func blow_up(area: Node2D) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	blow_up(area)
