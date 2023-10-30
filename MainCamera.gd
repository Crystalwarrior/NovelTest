extends Camera2D

var zoomtween: Tween
@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 50)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
@export_node_path var target  # Assign the node this camera will follow.

@export var point_collection: Node2D

var current_point: Node2D

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


func _unhandled_input(event):
	if not point_collection:
		return

	if event.is_action_pressed("ui_left"):
		var idx = (current_point.get_index() - 1) % point_collection.get_children().size()
		var point = point_collection.get_child(idx)
		set_campoint(point)
	if event.is_action_pressed("ui_right"):
		var idx = abs((current_point.get_index() + 1) % point_collection.get_children().size())
		var point = point_collection.get_child(idx)
		set_campoint(point)


func _ready():
	if point_collection:
		set_campoint(point_collection.get_child(0))


func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func set_campoint(point):
	if not point_collection:
		return

	if point is int:
		point = point_collection.get_child(point)
	current_point = point
	var scale_to = Vector2(1,1) / current_point.scale
	zoom_to(current_point.global_position, scale_to, 0.2)


func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)


func set_shake(amount):
	trauma = amount


func add_shake(amount):
	set_shake(trauma + amount)


func zoom_to(target_pos: Vector2, target_zoom: Vector2 = Vector2(1, 1), duration: float = 1.0):
	if zoomtween:
#		zoomtween.custom_step(9999)
		zoomtween.kill()
	zoomtween = create_tween()
	zoomtween.tween_property(self, "global_position", target_pos, duration).set_trans(Tween.TRANS_SINE)
	zoomtween.parallel().tween_property(self, "zoom", target_zoom, duration).set_trans(Tween.TRANS_SINE)
