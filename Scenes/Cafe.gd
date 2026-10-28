extends StaticBody2D

func _on_Area2D_area_entered(area):
	if area.is_in_group("ItemBox"):
		$AnimationPlayer.play("Collision")
		$Podskazka.visible = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("ItemBox"):
		$AnimationPlayer.play("NonCollision")
		$Podskazka.visible = false
