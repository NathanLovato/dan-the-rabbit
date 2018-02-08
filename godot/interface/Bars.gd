extends Control

var lifebar_node = preload('res://interface/LifeBar.tscn')

func _ready():
	for node in get_tree().get_nodes_in_group('character'):
		if not node.has_node('Health'):
			continue
		var health_node = node.get_node('Health')
		var new_lifebar = lifebar_node.instance()
		new_lifebar.initialize(node, health_node)
		node.get_node('LifeBarPivot').add_child(new_lifebar)
