class_name Room extends Node2D
@export var enemy_scene:PackedScene = preload("res://enemy/enemy.tscn")
@export var tree_scene:PackedScene = preload("res://tree.tscn")
@export var rock_scene:PackedScene = preload("res://rock.tscn")
@export var enemy_count:int = randi_range(2, 6)
@export var tree_count:int = randi_range(0,2)
@export var rock_count:int = randi_range(0,3)
@export var excluded_physics_layer:int = 0
@onready var floor_layer:TileMapLayer = $base
@onready var wall_layer:TileMapLayer = get_node_or_null("on top of base")
var spawned:= false

func _ready() -> void:
	PlayerManager.set_as_parent(self)
	RoomManager.room_load_start.connect(_free_level)
	MusicManager.play_music(MusicManager.cowboying)
	RoomManager.time_to_spawn.connect(spawn_enemies)
	
func _free_level():
	PlayerManager.unparent_player(self)
	queue_free()
	
func spawn_enemies():
	if spawned or not enemy_scene or not floor_layer:
		return
	spawned = true
	var blocked_tiles:Array[Vector2i] = wall_layer.get_used_cells() if wall_layer else []
	var open_tiles: Array[Vector2i]=[]
	
	for tile in floor_layer.get_used_cells():
		if blocked_tiles.has(tile):
			continue
		var tile_data := floor_layer.get_cell_tile_data(tile)
		if tile_data and tile_data.get_collision_polygons_count(excluded_physics_layer) == 0:
			open_tiles.append(tile)
	open_tiles.shuffle()
	
	for i in mini(enemy_count, open_tiles.size()):
		var enemy:= enemy_scene.instantiate() as Node2D
		enemy.global_position = floor_layer.to_global(floor_layer.map_to_local(open_tiles[i]))
		add_child(enemy)
	
	
		
