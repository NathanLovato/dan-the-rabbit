extends TextureProgress

var position_offset = Vector2()


func initialize(character_node, health_node):
	health_node.connect('health_changed', self, 'on_Health_health_changed')
	max_value = health_node.max_health
	value = health_node.health


func _ready():
	rect_position = -rect_size/2


func on_Health_health_changed(health):
	value = health
