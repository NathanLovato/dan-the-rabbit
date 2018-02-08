extends TextureProgress


func _ready():
#	set_as_toplevel(true)
#	rect_position = Vector2(100,100)
	var health_node = $"../Health"
	health_node.connect('health_changed', self, 'on_Health_health_changed')
	max_value = health_node.max_health
	value = health_node.health


func on_Health_health_changed(health):
	value = health
