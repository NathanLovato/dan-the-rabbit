extends "res://Character.gd"

const Pebble = preload("res://player/Pebble.tscn")


func _ready():
	pass


func _input(event):
	if event.is_action_pressed("attack") and not state == ATTACK:
		_change_state(ATTACK)
	elif event.is_action_pressed("throw"):
		_throw_pebble()


func _throw_pebble():
	var pebble_instance = Pebble.instance()
	pebble_instance.position = $PebbleSpawn.global_position
	pebble_instance.direction = last_move_direction
	$PebbleSpawn.add_child(pebble_instance)


func _physics_process(delta):
	input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
