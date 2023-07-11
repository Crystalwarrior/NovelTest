extends Node2D


@export var emote_switcher: AnimationPlayer = get_node_or_null("EmoteSwitcher")
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
		zoomtween.custom_step(9999)
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
	sprite_group.self_modulate.a = 1.0
	fade(true, duration)


func fadein(duration: float = 1.0):
	sprite_group.self_modulate.a = 0.0
	fade(false, duration)


func set_emote(emote):
	emote_switcher.play(emote)
	last_emote = emote


func get_savedict() -> Dictionary:
	if zoomtween:
		zoomtween.custom_step(9999)
		zoomtween.kill()
	if fadetween:
		fadetween.custom_step(9999)
		fadetween.kill()
	var save_dict = {
		"scene_file_path": scene_file_path,
		"emote": last_emote,
		"position": position,
		"rotation": rotation,
		"scale": scale,
		"self_modulate": sprite_group.self_modulate,
	}
	return save_dict


func load_savedict(save_dict: Dictionary):
	if zoomtween:
		zoomtween.kill()
	if fadetween:
		fadetween.kill()
	for key in save_dict.keys():
		var value = save_dict[key]
		if key == "emote":
			set_emote(value)
		if key == "position" or key == "rotation" or key == "scale":
			call_deferred("set", key, value)
		if key == "self_modulate":
			sprite_group.self_modulate = value
