extends CanvasLayer

func _ready():
	General.quest_animation_play = true
	$Control / Sprite / AnimationPlayer.play("QCA")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "QCA":
		$Control / Sprite / AnimationPlayer.play("QCAE")
	if anim_name == "QCAE":
		General.quest_animation_play = false
		queue_free()

func signal_start():
	$Control / Particles2D.emitting = true
	$Control / Particles2D.one_shot = true
