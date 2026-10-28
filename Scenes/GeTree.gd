extends Sprite

var area_enabled = true

func _ready():
	if area_enabled == false:
		$Area2D / CollisionShape2D.set_deferred("disabled", true)
	else:
		$Area2D / CollisionShape2D.set_deferred("disabled", false)

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		$Area2D / CollisionShape2D.set_deferred("disabled", true)

func eff_da():
	for i in [65, - 65]:
			var da = preload("res://Scenes/Effect.tscn").instance()
			get_parent().add_child(da)
			da.z_index = 99
			da.scale *= 1.9
			da.rotation_degrees = i
			da.Play("PunchWave")
			da.global_position = global_position
