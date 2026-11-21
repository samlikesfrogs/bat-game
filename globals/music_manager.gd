extends Node
var music_players_count:int = 2
var current_music_player:int = 0
var music_players = []
var music_fade_duration:float = 0.5
var cowboying = preload("res://sound/cowboying.wav")
var town = preload("res://sound/menu.wav")
var menu = preload("res://sound/town.wav")

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	for i in music_players_count:
		var music_player = AudioStreamPlayer.new()
		add_child(music_player)
		music_player.volume_db = -40.0
		music_players.append(music_player)

func play_music(bgm) -> void:
	if bgm == music_players[current_music_player].stream:
		return
	current_music_player+=1
	if current_music_player >1:
		current_music_player = 0
	var current_player:AudioStreamPlayer = music_players[current_music_player]
	current_player.stream = bgm
	fade_in(current_player)
	var old_player:AudioStreamPlayer = music_players[1]
	if current_music_player == 1:
		old_player = music_players[0]
	fade_out(old_player)
	
func fade_in(player:AudioStreamPlayer):
	player.play()
	var tween:Tween=create_tween()
	tween.tween_property(player, "volume_db", -25.0, music_fade_duration)
	
	
func fade_out(player:AudioStreamPlayer):
	var tween:Tween = create_tween()
	tween.tween_property(player, "volume_db", -40.0, music_fade_duration)
	await tween.finished
	player.stop()
	
