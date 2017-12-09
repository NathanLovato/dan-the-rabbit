extends "res://Character.gd"


func _input(event):
	if event.is_action_pressed("attack") and not state == ATTACK:
		_change_state(ATTACK)
	elif event.is_action_pressed("throw"):
		$PebbleSpawner.spawn_pebble()


func _physics_process(delta):
	input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	if input_direction and input_direction != last_move_direction:
		$PebbleSpawner.update_position(input_direction)
