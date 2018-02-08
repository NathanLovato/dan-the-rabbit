extends Node

signal health_changed
signal health_depleted

var health = 0
export(int) var max_health = 9

var status = null
enum STATUSES { NONE, INVINCIBLE, POISONED }
const POISON_DAMAGE = 1
const POISON_MAX_CYCLES = 3
var poison_cycles = 0


func _ready():
	health = max_health
	$PoisonTimer.connect('timeout', self, '_on_PoisonTimer_timeout')


func _change_status(new_status):
	match status:
		POISONED:
			$PoisonTimer.stop()

	match new_status:
		POISONED:
			poison_cycles = 0
			$PoisonTimer.start()
	status = new_status


func take_damage(amount):
	if status == INVINCIBLE:
		return
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
#	print("%s got hit and took %s damage. Health: %s/%s" % [get_name(), amount, health, max_health])


func heal(amount):
	health += amount
	health = max(health, max_health)
	emit_signal("health_changed", health)
#	print("%s got healed by %s points. Health: %s/%s" % [get_name(), amount, health, max_health])


func _on_PoisonTimer_timeout():
	poison_cycles += 1
	take_damage(POISON_DAMAGE)
	if poison_cycles == POISON_MAX_CYCLES:
		_change_status(NONE)
		return
	$PoisonTimer.start()