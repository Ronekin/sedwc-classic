extends Sprite


func _ready():
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
