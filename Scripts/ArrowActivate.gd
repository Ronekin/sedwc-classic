extends CPUParticles2D

signal stand_activate

onready var general = get_node("/root/General")


func _physics_process(delta):
	position.y = General.player_pos.y - 60
	position.x = General.player_pos.x
	z_index = 3

func _ready():
	if General.item_in_arm != "0":
		$AnimationPlayer.play("Idle" + General.item_in_arm)
		emitting = true
		one_shot = true
	

func _on_AnimationPlayer_animation_finished(anim_name):
	General.item_in_arm = "0"
	connect("stand_activate", general, "on_anim_activate_end")
	emit_signal("stand_activate")
	disconnect("stand_activate", general, "on_anim_activate_end")
	General.catscene_activated = false
	queue_free()
