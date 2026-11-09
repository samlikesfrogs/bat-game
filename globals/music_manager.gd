extends Node
var bgm = preload("res://sound/cowboying.wav")
var player = AudioStreamPlayer.new()
func _ready() -> void:
	player.stream = bgm
	await get_tree().process_frame
	get_tree().root.add_child(player)
	player.process_mode=Node.PROCESS_MODE_ALWAYS
	player.volume_db=-20.0
	player.play()
