extends Node2D


@export var emote_switcher: AnimationPlayer


func set_emote(emote):
	emote_switcher.play(emote)


func get_savedict() -> Dictionary:
	var save_dict = {
		"emote": emote_switcher.assigned_animation,
		"position": position,
		"rotation": rotation,
		"scale": scale,
	}
	return save_dict


func load_savedict(save_dict: Dictionary):
	for key in save_dict.keys():
		var value = save_dict[key]
		if key == "emote":
			set_emote(value)
		if key == "position" or key == "rotation" or key == "scale":
			set(key, value)
