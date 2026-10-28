extends Control

export var technic_id = 0

onready var player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")

func _ready():
	$AnimationPlayer.play(str(technic_id))
	if technic_id == 2:
		$Sprite.frame = 1
	if technic_id == 1:
		$Sprite.frame = 0
	if technic_id == 6:
		$Sprite.frame = 2
	if technic_id == 7:
		$Sprite.frame = 3
func _on_TouchScreenButton_pressed():
	if General.player_attack_activate == false and General.player_block_all == false and General.time_stop == false and General.time_erase == false and General.barrage_activate == false:
		General.techic_number = technic_id
		get_parent().get_parent().get_parent().get_parent().queue_free()
		General.stands_panel_activate = false
		
