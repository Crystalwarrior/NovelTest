extends OptionButton


@export var character: Node


func _ready():
	if not character:
		return
	var state = character.emote_switcher
	var animation_list = state.get_animation_list()
#	var default_index = 0
	for anim_index in animation_list.size():
		var anim = animation_list[anim_index]
#		if state.autoplay == anim:
#			default_index = anim_index
		add_item(anim)


func _on_item_selected(index):
	character.set_emote(get_item_text(index))
