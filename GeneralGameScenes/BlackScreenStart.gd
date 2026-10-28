extends CanvasLayer

func _on_BlackScreenAnimation_animation_finished(anim_name):
	if anim_name == "Start":
		$BlackScreenAnimation.play("Idle")

func _ready():
	$AnimationPlayer.play("Start")
	$BlackScreenAnimation.play("Go")
	yield($BlackScreenAnimation, "animation_finished")
	Transition.change_scene("res://GeneralGameScenes/GeneralMenu.tscn", "Black")
