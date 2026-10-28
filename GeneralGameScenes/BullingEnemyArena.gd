extends Node2D

func _ready():
	GeneralMusicPlayer.stream_paused = false
	GeneralMusicPlayer.theme_resong()
	General.glush_enemy_timer.wait_time = 1
	General.glush_enemy_timer.one_shot = true
	General.timer_service.ensure_autoload_timer(General, General.glush_enemy_timer)
	General.glush_enemy_timer.start()
	General.last_fight_area = "BullingEnemyArena"
	General.right_block_position = $YSorting / HitBoxBlock5.global_position
	General.left_block_position = $YSorting / HitBoxBlock4.global_position
	General.top_block_position = $YSorting / HitBoxBlock2.global_position
	General.bottom_block_positon = $YSorting / HitBoxBlock.global_position
	General.item_in_arm = "0"

