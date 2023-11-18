extends Node

@export var savefile_path = "user://main.save";

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_file = FileAccess.open(savefile_path, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("save")
	for node in save_nodes:
		# Check the node has a save function.
		if not node.has_method("get_savedict"):
			print("save node '%s' is missing a get_savedict() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("get_savedict")

		# Save the node path, always.
		node_data["nodepath"] = node.get_path()

		# Save the parent path too!
		node_data["parent"] = node.get_parent().get_path()

		# Store the save dictionary as a new line in the save file.
		save_file.store_var(node_data)


func load_game():
	if not FileAccess.file_exists(savefile_path):
		assert(false)
		return # Error! We don't have a save to load.

	var save_file = FileAccess.open(savefile_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var data = save_file.get_var()
		if not data.has("nodepath"):
			print("load data '%s' no nodepath found, skipped" % data)
			continue

		var node = get_tree().get_current_scene().get_node_or_null(data["nodepath"])
		if not node:
			if not data.has("scene_file_path") or not data.has("parent"):
				print("load node '%s' is not an instanced scene, skipped" % node.name)
				continue
			node = load(data["scene_file_path"]).instantiate()
			get_node(data["parent"]).add_child(node)
			node.add_to_group("save")
		if not node.has_method("load_savedict"):
			print("load node '%s' is missing a load_savedict() function, skipped" % node.name)
			continue

		node.load_savedict(data)
