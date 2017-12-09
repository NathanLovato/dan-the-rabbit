extends Control

const LifeBar = preload('res://interface/LifeBar.tscn')

func _ready():
	for node in get_tree().get_nodes_in_group('character'):
		if node.has_node('Health'):
			node.get_node('LifeBarSpawn').add_child(LifeBar.instance())

