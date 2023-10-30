extends Node2D

@export var talk_animationplayer: AnimationPlayer

@onready var emote_switcher: AnimationPlayer = get_node_or_null("EmoteSwitcher")
@onready var sprite_group: CanvasGroup = $SpriteGroup

var is_talking: bool = false

var talk_prefix = ""

var last_animation = ""
var last_animation_speed = 1.0

var last_emote = ""

var shaking: bool = false
var shaking_intensity: float = 5.0
var shaking_duration: float = 0.05
var shaking_interval: float = 0.05

var shaking_timer: float = 0

var fadetween: Tween
var colortween: Tween
var zoomtween: Tween
var shaketween: Tween
var fliptween: Tween
var bumptween: Tween

signal tween_finished

func _ready():
	set_emote(emote_switcher.autoplay)


func _process(delta):
	if shaking:
		shaking_timer += delta
		if shaking_timer >= shaking_interval:
			shake(shaking_intensity, shaking_duration)
			shaking_timer = 0


func _tween_finished():
	tween_finished.emit()


func bump():
	if bumptween:
		bumptween.custom_step(10000)
		bumptween.kill()
	bumptween = create_tween()
	bumptween.tween_property(sprite_group, "position:y", sprite_group.position.y - 3, 0.1)
	bumptween.tween_property(sprite_group, "position:y", sprite_group.position.y, 0.1)


func flip_h(tog: bool = true, duration: float = 0.2):
	if tog and sprite_group.scale.x < 0:
		return
	if not tog and sprite_group.scale.x > 0:
		return
	if fliptween:
		fliptween.custom_step(10000)
		fliptween.kill()
	if duration <= 0:
		sprite_group.scale.x = -sprite_group.scale.x
	else:
		fliptween = create_tween()
		fliptween.tween_property(sprite_group, "scale:y", sprite_group.scale.y / 1.02, duration/3)
		fliptween.tween_property(sprite_group, "scale:x", -sprite_group.scale.x, 0)
		fliptween.tween_property(sprite_group, "scale:y", sprite_group.scale.y * 1.02, duration/3)
		fliptween.tween_property(sprite_group, "scale:y", sprite_group.scale.y, duration/3)
		fliptween.finished.connect(_tween_finished, CONNECT_ONE_SHOT)


func set_emote(emote):
	emote_switcher.play(emote)
	talk_prefix = emote
	if talk_animationplayer:
		if is_talking:
			start_talking()
		else:
			stop_talking()
	last_emote = emote


func start_talking():
	is_talking = true
	if talk_animationplayer:
		talk_animationplayer.play(talk_prefix + "_talk")


func stop_talking():
	is_talking = false
	if talk_animationplayer:
		talk_animationplayer.play(talk_prefix + "_silent")


func move_to(target_pos: Vector2, target_scale: Vector2 = Vector2(1, 1), duration: float = 1.0, additive: bool = false):
	if zoomtween:
		zoomtween.custom_step(10000)
		zoomtween.kill()
	if additive:
		target_pos = position + target_pos
	if duration <= 0:
		position = target_pos
		return
	zoomtween = create_tween()
	zoomtween.tween_property(self, "position", target_pos, duration).set_trans(Tween.TRANS_CUBIC)
	zoomtween.parallel().tween_property(self, "scale", target_scale, duration).set_trans(Tween.TRANS_CUBIC)
	zoomtween.finished.connect(_tween_finished, CONNECT_ONE_SHOT)


func fade(out: bool = false, duration: float = 1.0):
	if fadetween:
		fadetween.kill()
	fadetween = create_tween()
	fadetween.tween_property(sprite_group, "self_modulate:a", 0 if out else 1, duration)
	fadetween.finished.connect(_tween_finished, CONNECT_ONE_SHOT)


func fadeout(duration: float = 1.0):
	sprite_group.self_modulate.a = 1.0
	fade(true, duration)


func fadein(duration: float = 1.0):
	sprite_group.self_modulate.a = 0.0
	fade(false, duration)


func fadecolor(to_color: Color = Color.WHITE, duration: float = 1.0):
	if colortween:
		colortween.kill()
	colortween = create_tween()
	colortween.parallel().tween_property(sprite_group, "self_modulate:r", to_color.r, duration)
	colortween.parallel().tween_property(sprite_group, "self_modulate:g", to_color.g, duration)
	colortween.parallel().tween_property(sprite_group, "self_modulate:b", to_color.b, duration)
	colortween.finished.connect(_tween_finished, CONNECT_ONE_SHOT)


func blackout(toggle: bool = false, duration: float = 1.0):
	fadecolor((Color.LIGHT_GRAY if toggle else Color.WHITE), duration)


func shake(intensity: float = 5.0, duration: float = 0.1):
	if shaketween:
		shaketween.kill()
	shaketween = create_tween()
	var target_pos = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
	shaketween.tween_property(sprite_group, "position", target_pos, duration)


func start_shaking(intensity: float = 3.0, duration: float = 0.05, interval: float = 0.05):
	shaking = true
	shaking_timer = 0
	shaking_intensity = intensity
	shaking_duration = duration
	shaking_interval = interval
	shake(shaking_intensity, shaking_duration)


func stop_shaking():
	shaking = false
	shaking_timer = 0
	if shaketween:
		shaketween.kill()
	shaketween = create_tween()
	shaketween.tween_property(sprite_group, "position", Vector2(0, 0), shaking_duration)


func get_savedict() -> Dictionary:
	if zoomtween:
		zoomtween.custom_step(10000)
		zoomtween.kill()
	if fadetween:
		fadetween.custom_step(10000)
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

