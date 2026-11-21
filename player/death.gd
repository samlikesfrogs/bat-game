class_name StateDeath extends State
@onready var sfx_ouch: AudioStreamPlayer2D = $sfx_ouch


# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	player.updateAnim("death")
	SaveManager.save_game()
	sfx_ouch.play()
	DifferentName.show_game_over()
	MusicManager.play_music(null)
	player.velocity = Vector2.ZERO
