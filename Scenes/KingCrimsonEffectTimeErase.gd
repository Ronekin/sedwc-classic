extends CanvasLayer

var screen_size_default = Vector2(640, 360)
var screen_player_size = OS.get_screen_size()

func _ready():
	var scale_k = (screen_player_size / screen_size_default) / 2
	if scale_k.x > scale_k.y:
		$Control / AnimatedSprite.scale = Vector2(scale_k.x + 0.2, scale_k.x + 0.2)
	else:
		$Control / AnimatedSprite.scale = Vector2(scale_k.y + 0.2, scale_k.y + 0.2)
	$Control / AnimatedSprite.frame = 0
	$Control / AnimatedSprite.playing = true
	$Control / AnimatedSprite.play("default")


func _on_AnimatedSprite_animation_finished():
	queue_free()
