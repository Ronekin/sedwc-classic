extends Control

export var stand_id = 0

onready var player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
signal stand_disactivate

func _ready():
	$AnimationPlayer.play(str(stand_id))

func _on_TouchScreenButton_pressed():
	if General.player_attack_activate == false and General.player_block_all == false and General.time_stop == false and General.time_erase == false and General.barrage_activate == false:
		if General.stand_activated:
			connect("stand_disactivate", player, "on_stand_activate")
			emit_signal("stand_disactivate")
			disconnect("stand_disactivate", player, "on_stand_activate")
			yield(get_tree().create_timer(0.3), "timeout")
			General.stand_number = stand_id
		else:
			General.stand_number = stand_id
		General.GGPlayer.addition.erase("NoArmor")
		get_parent().get_parent().get_parent().get_parent().queue_free()
		General.stands_panel_activate = false
		
	
