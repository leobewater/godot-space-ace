extends Area2D


const ROTATION_SPEED: float = 200.0
const SPEED: float = 40.0

var _player_ref: Player

func _ready():
	_player_ref = get_tree().get_first_node_in_group(GameData.GROUP_PLAYER)


func _process(delta):
	turn(delta)
	position += transform.x.normalized() * SPEED * delta


# calculate missle angle to to player position
func get_angle_to_player() -> float:
	if is_instance_valid(_player_ref) == false:
		return 0.0
		
	return rad_to_deg((_player_ref.global_position - global_position).angle())


func get_angle_to_turn(angle_to_player: float) -> float:
	return fmod((angle_to_player - global_rotation_degrees + 180.0), 360.0) - 180.0
	

func turn(delta: float) -> void:
	var angle_to_player = get_angle_to_player()
	var angle_to_turn = get_angle_to_turn(angle_to_player)

	if abs(angle_to_turn) < 180.0:
		rotation_degrees += sign(angle_to_turn) * delta * ROTATION_SPEED
	else:
		rotation_degrees += sign(angle_to_turn) * -1 * delta * ROTATION_SPEED


func blow_up() -> void:
	ObjectMaker.create_explosion(global_position, get_tree().current_scene)
	set_process(false)
	queue_free()


func _on_area_entered(area):
	blow_up()
