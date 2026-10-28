extends Control

func _ready():
	respawn()

func respawn():
	$CenterTopMessage.text = General.text_message
	$AnimationPlayer.play("Idle")

func _on_AnimationPlayer_animation_finished(_anim_name):
	General.item_name = ""
	General.message_activate = false
	queue_free()
