extends Node2D


var wave_list: WaveListResource = preload("res://wave_resources/wave_list.tres")


const ANIM_FRAMES = {
	GameData.ENEMY_TYPE.ZIPPER: ["zipper_1", "zipper_2", "zipper_3"],
	GameData.ENEMY_TYPE.BIO: ["biomech_1", "biomech_2", "biomech_3"],
	GameData.ENEMY_TYPE.BOMBER: ["bomber_1", "bomber_2", "bomber_3"],
}

const ENEMY_SCENES = {
	GameData.ENEMY_TYPE.ZIPPER: preload("res://enemies/enemy_zipper.tscn"),
	GameData.ENEMY_TYPE.BIO: preload("res://enemies/enemy_bio.tscn"),
	GameData.ENEMY_TYPE.BOMBER: preload("res://enemies/enemy_bomber.tscn")
}


@onready var paths = $Paths
@onready var spawn_timer = $SpawnTimer


var _paths_list: Array = []
var _wave_count: int = 0
var _last_path_index: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	_paths_list = paths.get_children()
	print(len(_paths_list))
	spawn_wave()


func create_enemy(speed: float, anim_name:String, en_type: GameData.ENEMY_TYPE):
	var new_en = ENEMY_SCENES[en_type].instantiate()
	new_en.setup(speed, anim_name)
	return new_en
	

func update_speeds() -> void:
	if _wave_count % len(_paths_list) == 0 and _wave_count != 0:
		wave_list.speed_factor *= 1.05
		wave_list.wave_gap *= 0.97
		print("update_speeds(): _wave_count:%s _speed_factor:%s _wave_gap:%s" % [
			_wave_count, wave_list.speed_factor, wave_list.wave_gap])
		
		
func start_spawn_timer() -> void:
	spawn_timer.wait_time = wave_list.wave_gap
	spawn_timer.start()
	

func get_random_path_index() -> int:
	var index = randi_range(0, len(_paths_list)-1)
	while index == _last_path_index:
		index = randi_range(0, len(_paths_list)-1)
	_last_path_index = index
	return index


func spawn_wave() -> void:
	var path = _paths_list[get_random_path_index()]
	
	var wave_res: WaveResource = wave_list.get_next_wave()
	
	var en_type = wave_res.enemy_type
	var anim = ANIM_FRAMES[en_type].pick_random()	
	
	print("\nspawn_wave()\n_last_path_index:", _last_path_index)
	print("wave_res:", wave_res)
	
	for num in range(randi_range(wave_res.min, wave_res.max)):
		path.add_child(create_enemy(wave_res.speed * wave_list.speed_factor, 
								anim, en_type))
		await get_tree().create_timer(wave_res.gap).timeout
	
	print("wave() spawned, waiting:", wave_list.wave_gap)
	_wave_count += 1
	await get_tree().create_timer(wave_list.wave_gap).timeout
	update_speeds()
	start_spawn_timer()


func _on_spawn_timer_timeout():
	spawn_wave()
