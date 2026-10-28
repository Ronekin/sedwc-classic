extends Node2D
var map_size = Vector2(10000, 6000)
var tile_size = 16
signal stand_activated_now
signal stand_attack_now
signal item_acitvate_now
signal dialog_activate_now
onready var message = preload("res://Scenes/Message.tscn")

onready var position_spawn_item = [Vector2(844, 96), Vector2(62, 873), Vector2(51, 1422)]


func _ready():
	General.last_fight_area = "MorioMap"
	General.is_tournir = false
	GeneralMusicPlayer.stream_paused = false
	if name != "Jail":
		General.right_block_position = $HitBoxBlock5.global_position
		General.left_block_position = $HitBoxBlock4.global_position
		General.top_block_position = $HitBoxBlock2.global_position
		General.bottom_block_positon = $HitBoxBlock.global_position
	connect("stand_activated_now", $SortingY / GGPlayer, "stand_activated_now")
	connect("stand_attack_now", $SortingY / GGPlayer, "stand_attack_now")
	connect("item_acitvate_now", $SortingY / GGPlayer, "item_activated_now")
	connect("dialog_activate_now", $SortingY / GGPlayer, "dialog_activate_now")

func _on_GUI_item_activate_go():
	emit_signal("item_acitvate_now")

func _on_GUI_stand_activate_go():
	emit_signal("stand_activated_now")

func _on_GUI_stand_attack_go():
	emit_signal("stand_attack_now")

func _on_GUI_dialog_activate_go():
	emit_signal("dialog_activate_now")

