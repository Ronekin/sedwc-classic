extends Line2D


export var leng = 50
export (NodePath) var Target = ""
var point = Vector2()


func _process(delta):
	global_position = Vector2(0, 0)
	global_rotation = 0
	if Target == "":
		point = get_parent().global_position
	else:
		point = get_node(Target).global_position
	
	add_point(point)
	while get_point_count() > leng:
		remove_point(0)
