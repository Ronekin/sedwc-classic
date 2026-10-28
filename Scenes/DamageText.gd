extends Label

func _ready():
	text = General.damage_text
	
func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().queue_free()
