extends StaticBody2D





var counter = 0


func _ready():
	pass
func _on_TouchScreenButton_pressed():
	if General.stand_number != 18:
		General.message_spawn("Center", "могущественный меч не поддаётся вашим усилиям")
	else:
			General.message_spawn("Center", "могущественный меч немного сдвинулся")
			$Anim.play("DA")
			counter += 1
			if counter >= 100:
				General.AchievementGive(39)
		
			
			
			
