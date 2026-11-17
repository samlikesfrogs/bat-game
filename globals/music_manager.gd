extends Node
var cowboying = preload("res://sound/cowboying.wav")
var town = preload("res://sound/menu.wav")
var menu = preload("res://sound/town.wav")
var player = AudioStreamPlayer.new()

func play_music(bgm) -> void:
	if bgm == null:
		pass
	player.stream = bgm
	await get_tree().process_frame
	if not get_tree().root.has_node("/root/@AudioStreamPlayer@28"):
		get_tree().root.add_child(player)
	player.process_mode=Node.PROCESS_MODE_ALWAYS
	player.volume_db=-28.0
	player.play()
	
func stop_music():
	player.queue_free()
