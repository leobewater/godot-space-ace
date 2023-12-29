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


# explosion not following enemy
func blow_up(area: Node2D) -> void:
	if area.is_in_group(GameData.GROUP_HOMING_MISSILE) == false:
		var net_position = global_position - area.global_position
		ObjectMaker.create_explosion(net_position, area)
	set_process(false)
	queue_free()


func get_damage() -> int:
	return _damage


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


# when bullet collides
func _on_area_entered(area):
	blow_up(area)
