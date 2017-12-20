extends Position2D

const Pebble = preload("res://characters/player/Pebble.tscn")

var start_position = Vector2()
var throw_direction = Vector2()

export(int) var offset = 45


func _ready():
	start_position = position


func spawn_pebble():
	var pebble_instance = Pebble.instance()
	pebble_instance.spawn_position = global_position
	pebble_instance.direction = throw_direction
	add_child(pebble_instance)


func update_position(look_direction):
	throw_direction = look_direction
	position = start_position + offset * throw_direction
