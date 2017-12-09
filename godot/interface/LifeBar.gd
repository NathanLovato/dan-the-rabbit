extends TextureProgress


func _ready():
	var health_node = $"../Health"
	health_node.connect('health_changed', self, 'on_Health_health_changed')
	max_value = health_node.max_health
	value = health_node.health


func on_Health_health_changed(health):
	value = health
