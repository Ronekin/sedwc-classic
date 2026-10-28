extends Particles2D

func _ready():
	if General.stand_index == "TuskAct2":
		$AnimationPlayer.play(General.vfx_stand_random)
	elif General.stand_index == "TuskAct1":
		$AnimationPlayer.play(General.stand_index)
	elif General.stand_index == "Soft&Wet":
		$AnimationPlayer.play("TuskAct1")

func _physics_process(delta):
	if emitting == false:
		queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("YSortGroup"):
		z_index -= 3
	
func _on_Area2D_area_exited(area):
	if area.is_in_group("YSortGroup"):
		z_index += 3
