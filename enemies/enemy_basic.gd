extends PathFollow2D


@export var shoots: bool = false
@export var aims_at_player:bool = false
@export var bullet_scene: PackedScene
@export var bullet_damage: int = 10
@export var bullet_speed: float = 120.0
@export var bullet_direction: Vector2 = Vector2.DOWN
@export var bullet_wait_time: float = 3.0
@export var bullet_wait_time_var: float = 0.05 # variation

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var laser_timer = $LaserTimer
@onready var booms = $Booms


var _player_ref: Player
var _speed: float
var _can_shoot: bool = false
var _dead: bool = false
var _anim_string: String


func _ready():
	_player_ref = get_tree().get_first_node_in_group(GameData.GROUP_PLAYER)
	if !_player_ref: 
		queue_free()
	animated_sprite_2d.play(_anim_string)


func setup(speed: float, anim_name: String) -> void:
	_speed = speed
	_anim_string = anim_name
	

func _process(delta):
	# progress_ratio is object moving on the path progress
	progress_ratio += _speed * delta
	
	if progress_ratio > 0.99:
		queue_free()


func start_shoot_timer() -> void:
	laser_timer.wait_time = bullet_wait_time
	laser_timer.start()


func shoot() -> void:
	var b = bullet_scene.instantiate()
	b.setup(
		global_position,
		bullet_direction,
		bullet_speed,
		bullet_damage
	)
	get_tree().root.add_child(b)
	start_shoot_timer()
	
	
func _on_laser_timer_timeout():
	shoot()


func _on_visible_on_screen_notifier_2d_screen_entered():
	if shoots == true:
		start_shoot_timer()


func _on_visible_on_screen_notifier_2d_screen_exited():
	set_process(false)
	queue_free()


func _on_hit_box_area_entered(area):
	pass # Replace with function body.
