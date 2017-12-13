extends Area2D

signal attack_finished

var state = null
enum STATES { IDLE, ATTACK }

var hit_objects = []

export(int) var power = 2


func _ready():
	$AnimationPlayer.connect('animation_finished', self, "_on_animation_finished")
	_change_state(IDLE)


# Weapon.gd
func _change_state(new_state):
	# Clean up previous state
	match state:
		ATTACK:
			hit_objects = []

	# Initialize the new state
	match new_state:
		IDLE:
			$AnimationPlayer.play('idle')
			monitoring = false
		ATTACK:
			$AnimationPlayer.play('attack')
			monitoring = true
	state = new_state


func _physics_process(delta):
	if state == ATTACK:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			var unique_id = body.get_rid().get_id()
			if unique_id in hit_objects:
				continue
			if body.has_node("Health") and not body.is_a_parent_of(self):
				body.get_node("Health").take_damage(power)
				hit_objects.append(body.get_rid().get_id())


func _on_animation_finished(name):
	if name == "attack":
		_change_state(IDLE)
		emit_signal("attack_finished")


func attack():
	_change_state(ATTACK)
