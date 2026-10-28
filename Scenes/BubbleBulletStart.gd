extends Sprite

onready var bubble_effect = preload("res://Scenes/Explosion.tscn")

func _ready():
	General.bubble_go_beyound_start_activate = true

func _physics_process(delta):
	if General.bubble_bey_stop:
		visible = false
		$AnimationPlayer.stop(true)
		var bubble = bubble_effect.instance()
		get_parent().add_child(bubble)
		
		bubble.global_position = global_position
		General.bubble_bey_stop = false
		General.bubble_go_beyound_start_activate = false
		queue_free()

