extends Area2D

# TODO: calculate it
const START_HEIGHT = 57
const GRAVITY = 500

const SPEED = 1800
const MAX_THROW_DISTANCE = 800

var direction = Vector2()
var motion = Vector2()

var height = 0
var fall_speed = 0.0

var flown_distance = 0

const LIFETIME = 2.0
var timer = 0.0


func _ready():
	set_as_toplevel(true)
	height = START_HEIGHT


func _physics_process(delta):
	timer += delta
	if timer > LIFETIME:
		queue_free()

	if flown_distance >= MAX_THROW_DISTANCE:
		return
	fall_speed += GRAVITY * delta

	motion = direction.normalized() * SPEED * delta
	motion.y += fall_speed * delta

	flown_distance += abs(motion.length())
	position += motion

	var bodies = get_overlapping_bodies()
