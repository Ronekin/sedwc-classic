extends Sprite

var random = RandomNumberGenerator.new()

func _ready():
	General.arm_barrage_count += 1
	$AudioStreamPlayer2.play()
	if General.player_direct == "left":
		scale.x = 1
	else:
		scale.x = - 1
	random.randomize()
	$AnimationPlayer.play("Idle" + str(random.randi_range(1, 3)))


func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		$Area2D / CollisionShape2D.set_deferred("disabled", true)
		$AudioStreamPlayer.play()
