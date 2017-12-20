extends Node

signal health_changed
signal health_depleted

var health = 0
export(int) var max_health = 9


func _ready():
	health = max_health


func take_damage(damage):
	health -= damage
	if health <= 0:
		health = 0
	emit_signal("health_changed", health)
	print("%s got hit. Took %s damage" % [get_name(), damage])
	print("Its health is at %s/%s" % [health, max_health])
