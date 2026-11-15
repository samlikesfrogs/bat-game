extends Node
var cowboying = preload("res://sound/cowboying.wav")
var town = preload("res://sound/menu.wav")
var menu = preload("res://sound/town.wav")
var player = AudioStreamPlayer.new()

func play_music(bgm) -> void:
	player.stream = bgm
	await get_tree().process_frame
	get_tree().root.add_child(player)
	player.process_mode=Node.PROCESS_MODE_ALWAYS
	player.volume_db=-28.0
	player.play()
	
func stop_music():
	player.queue_free()
