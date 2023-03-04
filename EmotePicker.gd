extends OptionButton


@export var character: Node


func _ready():
	var state = character.emote_switcher
	var animation_list = state.get_animation_list()
	var default_index = 0
	for anim_index in animation_list.size():
		var anim = animation_list[anim_index]
		if state.autoplay == anim:
			default_index = anim_index
		state.play(anim)
		add_item(anim)


func _on_item_selected(index):
	var state = character.emote_switcher
	state.play(get_item_text(index))
