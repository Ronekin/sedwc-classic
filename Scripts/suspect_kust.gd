extends StaticBody2D
var stage = 0
export var garden_id = - 1
func _process(delta):
	if General.timer_grass == 1:
		$Sprite2 / Grass.visible = true
		$Area2D.add_to_group("collect_grass")
	elif General.timer_grass == 0:
		$Sprite2 / Grass.visible = false
		if $Area2D.is_in_group("collect_grass"):
			$Area2D.remove_from_group("collect_grass")
