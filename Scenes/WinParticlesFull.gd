extends CanvasLayer


func _ready():
	$Control / Particles2D.emitting = true
	$Control2 / Particles2D2.emitting = true
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
