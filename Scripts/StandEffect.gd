extends Particles2D

func _ready():

	if General.stand_index != "None":
		$AnimationPlayer.play(General.stand_index + "Idle")

func _physics_process(delta):
	position.y = General.player_pos.y - 60
	position.x = General.player_pos.x
	if emitting == false:
		queue_free()
