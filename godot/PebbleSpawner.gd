extends Position2D

const Pebble = preload("res://Player/Pebble.tscn")

var parent_direction = Vector2(1, 0)
var start_position = Vector2()
export(int) var offset = 45


func _ready():
	start_position = position

	$"..".connect("pebble_thrown", self, "_on_Parent_pebble_thrown")
	$"..".connect("direction_changed", self, "_on_Parent_direction_changed")


func _spawn_pebble():
	var pebble_instance = Pebble.instance()
	pebble_instance.spawn_position = global_position
	pebble_instance.direction = parent_direction
	add_child(pebble_instance)


func _on_Parent_pebble_thrown():
	_spawn_pebble()


func _on_Parent_direction_changed(new_direction):
	parent_direction = new_direction.normalized()
	position = start_position + offset * parent_direction
