extends Camera2D

@export var point_collection: Node2D

var current_point: Node2D
var tween: Tween


func _ready():
	set_campoint(point_collection.get_child(0))


func _input(event):
	if event.is_action_pressed("ui_left"):
		var idx = (current_point.get_index() - 1) % point_collection.get_children().size()
		var point = point_collection.get_child(idx)
		set_campoint(point)
	if event.is_action_pressed("ui_right"):
		var idx = abs((current_point.get_index() + 1) % point_collection.get_children().size())
		var point = point_collection.get_child(idx)
		set_campoint(point)


func set_campoint(point):
	if point is int:
		point = point_collection.get_child(point)
	current_point = point
	pan_to(current_point.global_position)


func pan_to(pos):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", pos, 0.2)
