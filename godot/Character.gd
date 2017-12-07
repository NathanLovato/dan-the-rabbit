extends KinematicBody2D


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

var weapon = null


func _ready():
	_change_state(IDLE)
	weapon = $Pivot/WeaponSpawn.get_child(0)
	weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")


func _change_state(new_state):
#	print(new_state)
	# Clean up the previous state
#	match state:
#		DEAD:
#			pass

	# Initialize the new state
	match new_state:
		IDLE:
			speed = 0
		MOVE:
			speed = 200
		ATTACK:
			weapon.attack()
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

		velocity = input_direction * speed * delta
		move_and_collide(velocity)


func _on_Weapon_attack_finished():
	_change_state(IDLE)
