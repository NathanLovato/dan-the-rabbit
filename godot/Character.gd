extends KinematicBody2D

signal changed_state

#MOTION
const MAX_WALK_SPEED = 450
const MAX_RUN_SPEED = 700

var speed = 0
var max_speed = 0

var input_direction = Vector2()
var look_direction = Vector2(1, 0)
var last_move_direction = Vector2(1, 0)

var velocity = Vector2()

enum STATES { IDLE, MOVE, ATTACK, STAGGER, DIE, DEAD }
var state = null

export(PackedScene) var weapon_scene = null
var weapon = null


func _ready():
	_change_state(IDLE)
	$AnimationPlayer.connect('animation_finished', self, '_on_AnimationPlayer_animation_finished')
	$Health.connect('health_changed', self, '_on_Health_health_changed')

	if not weapon_scene:
		return
	$Pivot/WeaponSpawn.add_child(weapon_scene.instance())
	weapon = $Pivot/WeaponSpawn.get_child(0)
	weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
	self.connect("changed_state", weapon, "_on_Character_changed_state")


func _change_state(new_state):
	# Initialize the new state
	match new_state:
		IDLE:
			speed = 0
			$AnimationPlayer.play('idle')
		MOVE:
			speed = 200
			$AnimationPlayer.play('walk')
		ATTACK:
			if not weapon:
				_change_state(IDLE)
				return
			$AnimationPlayer.play('idle')
			emit_signal("changed_state", "attack")
		STAGGER:
			$AnimationPlayer.play('stagger')
		DIE:
			$AnimationPlayer.play('die')
		DEAD:
			queue_free()
	state = new_state


func _physics_process(delta):
	if input_direction.x:
		if input_direction.x != look_direction.x:
			look_direction.x = input_direction.x
			# Can't scale a Body directly - scale another node2d
			$Pivot.set_scale(Vector2(look_direction.x, 1))

	if input_direction:
		last_move_direction = input_direction

	if state == IDLE:
		if input_direction:
			_change_state(MOVE)
	elif state == MOVE:
		if Input.is_action_pressed("run"):
			max_speed = MAX_RUN_SPEED
		else:
			max_speed = MAX_WALK_SPEED

		if input_direction:
			speed = max_speed
		else:
			speed = 0
			_change_state(IDLE)
#		speed = clamp(speed, 0, max_speed)

		velocity = input_direction.normalized() * speed * delta
		move_and_collide(velocity)


func _on_Weapon_attack_finished():
	_change_state(IDLE)


func _on_AnimationPlayer_animation_finished(name):
	if name == 'die':
		_change_state(DEAD)


func _on_Health_health_changed(new_health):
	if new_health == 0:
		_change_state(DIE)
	else:
		_change_state(STAGGER)
