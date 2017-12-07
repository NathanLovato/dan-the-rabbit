extends Node

signal health_changed

var health = 0
export(int) var max_health = 4


func _ready():
	health = max_health


func take_damage(damage):
	health -= damage
	if health <= 0:
		health = 0
	print("%s got hit. Took %s damage" % [get_name(), health])
	emit_signal("health_changed", health)
