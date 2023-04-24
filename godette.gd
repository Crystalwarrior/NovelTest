extends Node2D


@export var emote_switcher: AnimationPlayer


func set_emote(emote):
	emote_switcher.play(emote)
