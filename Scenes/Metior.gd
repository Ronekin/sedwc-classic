extends Node2D

var timer = 0.0






func _ready():
	if randf() > 0.5:
		$Sprite.frame = 1
		



func _process(delta):
	global_position.x += delta * 500
	timer += delta
	if timer > 5:
		queue_free()
