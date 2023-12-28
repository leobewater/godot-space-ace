extends PathFollow2D


@onready var state_machine = $AnimationTree["parameters/playback"]


const SPEED: float = 0.08
const SHOOT_PROGRESS: float = 0.02 # progress margin
const FIRE_OFFSETS = [0.25, 0.5, 0.75] # shoot at 25%, 50%, 75% on the path progress

var _shooting: bool = false
var _shots_fired: int = 0  # index for FIRE_OFFSETS


func _ready():
	progress_ratio = 0.0


func _process(delta):
	if _shooting == false:
		progress_ratio += SPEED * delta


func update_shots_fired() -> void:
	_shots_fired += 1
	# reset shots_fired when it's out of bounce of the FIRE_OFFSETS array
	if _shots_fired >= len(FIRE_OFFSETS):
		_shots_fired = 0 


func try_shoot() -> void:
	if abs(progress_ratio - FIRE_OFFSETS[_shots_fired]) < SHOOT_PROGRESS:
		# tell animationTree to travel to shoot
		state_machine.travel("shoot")


func set_shooting(v: bool) -> void:
	_shooting = v
