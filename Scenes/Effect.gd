extends Node2D








func _ready():
	pass





func Play(eff):
	$AnimationPlayer.play(eff)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
