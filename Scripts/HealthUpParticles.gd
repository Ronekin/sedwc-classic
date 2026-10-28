extends Particles2D


func _physics_process(delta):
	position.y = General.player_pos.y - 30
	position.x = General.player_pos.x
	if emitting == false:
		queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("YSortGroup"):
		z_index -= 3


func _on_Area2D_area_exited(area):
	if area.is_in_group("YSortGroup"):
		z_index += 3
