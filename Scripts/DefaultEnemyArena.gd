extends Node2D

func _ready():
	GeneralMusicPlayer.theme_resong()
	GeneralMusicPlayer.stream_paused = false
	General.glush_enemy_timer.wait_time = 1
	General.glush_enemy_timer.one_shot = true
	General.timer_service.ensure_autoload_timer(General, General.glush_enemy_timer)
	General.glush_enemy_timer.start()
	General.last_fight_area = "DefaultEnemyArena"
	General.right_block_position = $YSorting / HitBoxBlock5.global_position
	General.left_block_position = $YSorting / HitBoxBlock4.global_position
	General.top_block_position = $YSorting / HitBoxBlock2.global_position
	General.bottom_block_positon = $YSorting / HitBoxBlock.global_position
	General.item_in_arm = "0"
	# StaticBody2D есть только в некоторых аренах. Не требуем его от каждой
	# арены: get_node_or_null не печатает ошибку при отсутствии.
	var light_body = get_node_or_null("StaticBody2D")
	if light_body != null:
		if General.fight_with == 1:
			light_body.visible = true
			var shape = light_body.get_node_or_null("CollisionShape2D")
			if shape != null:
				shape.disabled = false
			var light = light_body.get_node_or_null("Light2D")
			if light != null:
				light.energy = 0
		else:
			light_body.visible = false



func ZeckPlant(zeck_body: Object):
	var da = Sprite.new()
	da.texture = load("res://Textures/Details/GreenBabyPlant.png")
	da.hframes = 5
	da.scale = Vector2(2, 2)
	zeck_body.add_child(da)
	da.position = Vector2(0, 14)
	for i in 10:
		zeck_body.modulate -= Color(0.04, 0.04, 0.04, 0)
		yield(get_tree().create_timer(0.05), "timeout")
	for i in 4:
		da.frame += 1
		yield(get_tree().create_timer(0.2), "timeout")
