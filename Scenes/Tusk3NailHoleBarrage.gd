extends Node2D

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		$Sprite4 / Area2D / CollisionShape2D.set_deferred("disabled", true)
		$DAMAGE.play()
func _ready():
	if General.stand_number == 11:
		$Sprite4.frame = 1
		$Sprite4 / Line2D.default_color = "fff6bb"
	if General.stand_number == 9:
		$Sprite4.frame = 0
		$Sprite4 / Line2D.default_color = "bbfffc"
		
