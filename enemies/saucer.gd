extends PathFollow2D

var missile_scene: PackedScene = preload("res://missile/homing_missile.tscn")


@onready var state_machine = $AnimationTree["parameters/playback"]
@onready var health_bar = $HealthBar
@onready var booms = $Booms


const SPEED: float = 0.08
const SHOOT_PROGRESS: float = 0.02 # progress margin
const FIRE_OFFSETS = [0.25, 0.5, 0.75] # shoot at 25%, 50%, 75% on the path progress
const BOOM_DELAY: float = 0.15
const HIT_DAMAGE: float = 40
const SCORE: float = 150

var _shooting: bool = false
var _shots_fired: int = 0  # index for FIRE_OFFSETS


func _ready():
	progress_ratio = 0.0


func _process(delta):
	if _shooting == false:
		progress_ratio += SPEED * delta
		try_shoot()


func update_shots_fired() -> void:
	_shots_fired += 1
	# reset shots_fired when it's out of bounce of the FIRE_OFFSETS array
	if _shots_fired >= len(FIRE_OFFSETS):
		_shots_fired = 0 


func try_shoot() -> void:
	if abs(progress_ratio - FIRE_OFFSETS[_shots_fired]) < SHOOT_PROGRESS:
		# tell animationTree to travel to shoot
		state_machine.travel("shoot")
		update_shots_fired()


func set_shooting(v: bool) -> void:
	_shooting = v


func shoot() -> void:
	var missile = missile_scene.instantiate()
	get_tree().current_scene.add_child(missile)
	missile.global_position = global_position


func die() -> void:
	ScoreManager.increment_score(SCORE)
	queue_free()
	
	
# creats booms for multiple Marker2D
func make_booms() -> void:
	for b in booms.get_children():
		ObjectMaker.create_boom(b.global_position)
		# add timeout between each boom
		await get_tree().create_timer(BOOM_DELAY).timeout
	
	
func _on_health_bar_died():
	# disconnect this signal after the saucer died
	health_bar.disconnect("died", _on_health_bar_died)
	# travel animation to death
	state_machine.travel("death")


func _on_hit_box_area_entered(area):
	health_bar.take_damage(HIT_DAMAGE)
