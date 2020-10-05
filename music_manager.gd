extends Node

func fade_to_store():
	fade($game_music, $store_music)

func fade_to_game():
	fade($store_music, $game_music)

func fade(from : AudioStreamPlayer, to : AudioStreamPlayer):
	to.volume_db = -80
	to.play(from.get_playback_position())
	
	$tween.interpolate_property(from, "volume_db", -6, -80, 3, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$tween.interpolate_property(to, "volume_db", -80, -6, 2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()


