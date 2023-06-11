extends Node2D


@export var emote_switcher: AnimationPlayer

var last_animation = ""
var last_animation_speed = 1.0

var last_emote = ""


func _ready():
	set_emote(emote_switcher.autoplay)


func set_emote(emote):
	emote_switcher.play(emote)
	last_emote = emote


func get_savedict() -> Dictionary:
	var save_dict = {
		"emote": last_emote,
		"position": position,
		"rotation": rotation,
		"scale": scale,
		"self_modulate": self_modulate,
		"animation": [$AnimationPlayer.current_animation, $AnimationPlayer.get_playing_speed()],
	}
	print(last_emote)
	return save_dict


func load_savedict(save_dict: Dictionary):
	for key in save_dict.keys():
		var value = save_dict[key]
		print(key)
		if key == "emote":
			set_emote(value)
			print("emote: ", value)
		if key == "position" or key == "rotation" or key == "scale" \
		or key == "self_modulate":
			call_deferred("set", key, value)
		if key == "animation":
			if save_dict[key][0] == "":
				$AnimationPlayer.stop()
			else:
				$AnimationPlayer.play(value[0], -1, value[1], value[1] < 0)


func _on_animation_player_animation_started(anim_name):
	last_animation = $AnimationPlayer.current_animation
	last_animation_speed = $AnimationPlayer.get_playing_speed()
