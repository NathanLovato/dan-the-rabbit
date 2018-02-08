extends Area2D

signal attack_finished

const MAX_COMBO_COUNT = 3

enum STATES { IDLE, ATTACK }
var state = null

enum ATTACK_INPUT_STATES { IDLE, LISTENING, REGISTERED }
var attack_input_state = IDLE
var ready_for_next_attack = false

var combo_count = 0
var attack_current = {}
var combo = [
	{
		'damage': 1,
		'animation': 'attack_fast'
	},
	{
		'damage': 1,
		'animation': 'attack_fast'
	},
	{
		'damage': 3,
		'animation': 'attack_medium'
	}
]

var hit_objects = []


func _ready():
	$AnimationPlayer.stop()
	$AnimationPlayer.connect('animation_finished', self, "_on_animation_finished")
	_change_state(IDLE)


func _change_state(new_state):
	match state:
		ATTACK:
			hit_objects = []
			attack_input_state = IDLE
			ready_for_next_attack = false

	match new_state:
		IDLE:
			set_physics_process(false)
			$AnimationPlayer.play('idle')
			combo_count = 0
			monitoring = false
		ATTACK:
			set_physics_process(true)
			attack_current = combo[combo_count -1]
			$AnimationPlayer.play(attack_current['animation'])
			monitoring = true
	state = new_state


func _input(event):
	if not state == ATTACK:
		return
	if attack_input_state != LISTENING:
		return
	if event.is_action_pressed('attack'):
		attack_input_state = REGISTERED


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_rid().get_id() in hit_objects:
			continue
		if body.has_node("Health") and not body.is_a_parent_of(self):
			body.get_node("Health").take_damage(attack_current['damage'])
			hit_objects.append(body.get_rid().get_id())

	if attack_input_state == REGISTERED and ready_for_next_attack:
		attack()


func attack():
	if combo_count >= MAX_COMBO_COUNT:
		return
	combo_count += 1
	_change_state(ATTACK)


func _on_animation_finished(name):
	if not attack_current or name != attack_current['animation']:
		return

	if attack_input_state == REGISTERED:
		attack()
	else:
		_change_state(IDLE)
		emit_signal("attack_finished")


# Below: use with AnimationPlayer func track
func set_attack_input_listening():
	attack_input_state = LISTENING


func set_ready_for_next_attack():
	ready_for_next_attack = true