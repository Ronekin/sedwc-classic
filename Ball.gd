extends Node2D
export var BallNumber = 0




var gold_skin = preload("res://Textures/Details/BallGold.png")
var caramel_skin = preload("res://Textures/Details/ballCaramel.png")
var default_skin = preload("res://Textures/Details/Ball.png")

func _ready():
	pass



func _process(delta):
	if General.choose_skins["spin"] == "default":
		$BallBg.texture = default_skin
		$BallBg.modulate = "fcff00"
	elif General.choose_skins["spin"] == "gold":
		$BallBg.texture = gold_skin
		$BallBg.modulate = "fcff00"
	elif General.choose_skins["spin"] == "caramel":
		$BallBg.texture = caramel_skin
		$BallBg.modulate = "ffffff"
	$Particles2D.visible = $BallBg.frame != 6
	if General.techic_number in [1, 2]:
		visible = true
		
		if General.Addition["spin"] > 95 and $Particles2D.modulate.a == 0:
			$Effect.play("Full")
		elif General.Addition["spin"] < 95 and $Particles2D.modulate.a == 1:
			$Effect.play("No")
		
		if General.Addition["balls"][BallNumber] == true:
				$AnimationPlayer.play("Start")
				$AnimationPlayer.playback_speed = General.Addition["spin"] / 10
				var matDa: CanvasItemMaterial = $Particles2D.material
				if General.techic_number == 1:
					$Light.modulate = Color("8ab5ffb1")
					$Particles2D.color = Color("c5ff52")
					
					matDa.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
					
				elif General.techic_number == 2:
					$Light.modulate = Color("fffb00")
					$Particles2D.color = Color("fff180")
					matDa.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
				
				
		else:
				$AnimationPlayer.play("Empty")
	else:
		visible = false
		$AnimationPlayer.stop()
		





	

