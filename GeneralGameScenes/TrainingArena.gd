extends Node2D

func _ready():
	GeneralMusicPlayer.theme_resong()
	GeneralMusicPlayer.stream_paused = false
	General.last_fight_area = "TrainingArena"
	General.right_block_position = $YSorting / HitBoxBlock5.global_position
	General.left_block_position = $YSorting / HitBoxBlock4.global_position
	General.top_block_position = $YSorting / HitBoxBlock2.global_position
	General.bottom_block_positon = $YSorting / HitBoxBlock.global_position
	General.item_in_arm = "0"
