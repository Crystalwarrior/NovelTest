extends Node2D


@export var emote_switcher: AnimationPlayer
@onready var sprite_group: CanvasGroup = $SpriteGroup

var last_animation = ""
var last_animation_speed = 1.0

var last_emote = ""

var fadetween: Tween
var zoomtween: Tween


func _ready():
	set_emote(emote_switcher.autoplay)


func zoom_to(target_pos: Vector2, target_scale: Vector2 = Vector2(1, 1), duration: float = 1.0):
	if zoomtween:
		zoomtween.kill()
	zoomtween = create_tween()
	zoomtween.tween_property(self, "position", target_pos, duration).set_trans(Tween.TRANS_CUBIC)
	zoomtween.parallel().tween_property(self, "scale", target_scale, duration).set_trans(Tween.TRANS_CUBIC)


func fade(out: bool = false, duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	fadetween = create_tween()
	fadetween.tween_property(sprite_group, "self_modulate:a", 0 if out else 1, duration)


func fadeout(duration: float = 1.0):
	fade(true, duration)


func fadein(duration: float = 1.0):
	fade(false, duration)


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


func _on_animation_player_animation_started(_anim_name):
	last_animation = $AnimationPlayer.current_animation
	last_animation_speed = $AnimationPlayer.get_playing_speed()
