extends KinematicBody2D

# TODO: calculate it
const START_HEIGHT = 57
const GRAVITY = 500

var spawn_position = Vector2()

const SPEED = 1800
const MAX_THROW_DISTANCE = 800

var direction = Vector2()
var motion = Vector2()

var height = 0
var fall_speed = 0.0

var flown_distance = 0

export(float) var LIFETIME = 2.0
var timer = 0.0


func _ready():
	set_as_toplevel(true)
	position = spawn_position
	height = START_HEIGHT
	
	$Timer.wait_time = LIFETIME
	$Timer.connect('timeout', self, '_on_Timer_timeout')
	$Timer.start()


func _physics_process(delta):
	if flown_distance >= MAX_THROW_DISTANCE:
		return
	fall_speed += GRAVITY * delta

	motion = direction.normalized() * SPEED * delta
	motion.y += fall_speed * delta

	flown_distance += abs(motion.length())
	var collision_info = move_and_collide(motion)

	if not collision_info:
		return
	$CollisionShape2D.disabled = true
	set_physics_process(false)


func _on_Timer_timeout():
	queue_free()
