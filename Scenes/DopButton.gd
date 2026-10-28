extends TouchScreenButton

var barrage_timer: Timer = null
var bubble_beyound_timer: Timer = null
var barrage_timer_will_end = true
var time_last = 0.0
var attack_started = false
export var attack_id = 0
var pressed_activate = false
var knife_count = 3
var epit_count = 2
var knife_twoh_count = 3
var spin_nail_count = 3
var speed_boost = 1
onready var epitafia_effect = preload("res://Scenes/EpitafiaEffect.tscn")
signal ts_twoh
signal health_ge_up
signal overwrite_twoh_self
signal zahvat_hg_enemy
signal armor_scr_go
signal overwrite_twoh_enemy
signal za_warudo_tw
signal knife_tw_go
signal weapon_scr_go
signal tea_go
signal chop_kc_go
signal barrage_ge_go
signal barrage_tw_go
signal barrage_twoh_go
signal barrage_saw_go
signal barrage_scretro_go
signal tusk2_hole_go
signal echoes_glush_go
signal bubble_saw_go
signal bubble_saw_go_bey
signal bubble_saw_go_bey_start
signal spin_nail_go
signal epit_kc_go
signal time_erase_kc
signal barrage_e1_go
signal za_warudo_sp
signal barrage_sp_go
signal ge_tree_spawn
signal ger_tree_spawn
signal twoh_light_spawn
signal tusk_3_hole_go
signal tusk_3_bd_go
signal sp_starfinger_go
signal black_hole_save
signal johny_awakening_go
signal tusk_4_bd_go
signal tusk_4_counter
signal shadow_tw_ts

signal enemy_timer_timestop_tw
signal enemy_timer_timestop_sp
signal enemy_timer_timestop_shadowtw
signal enemy_timer_timestop_twoh

var imBarrage: bool = false
var imBeatDown: bool = false
var CoolDown: bool = false
var CoolDownId: int = 0


var life_timer_check = Timer.new()

var is_barrage_timer_active = false
var is_bubble_timer_active = false

func _ready():
	
	life_timer_check.connect("timeout", self, "_on_life_timer_check")
	life_timer_check.wait_time = 60.0
	life_timer_check.one_shot = false
	add_child(life_timer_check)
	life_timer_check.start()
	
	
	barrage_timer = Timer.new()
	barrage_timer.one_shot = true
	add_child(barrage_timer)
	
	bubble_beyound_timer = Timer.new()
	bubble_beyound_timer.one_shot = true
	add_child(bubble_beyound_timer)

func _on_life_timer_check():
	
	if barrage_timer and not barrage_timer.is_inside_tree() and barrage_timer != null:
		if not barrage_timer.is_queued_for_deletion():
			barrage_timer.queue_free()
	if bubble_beyound_timer and not bubble_beyound_timer.is_inside_tree() and bubble_beyound_timer != null:
		if not bubble_beyound_timer.is_queued_for_deletion():
			bubble_beyound_timer.queue_free()


func is_timer_active(timer) -> bool:
	if not is_instance_valid(timer):
		return false
	return timer.time_left > 0 and not timer.is_stopped()

func _physics_process(delta):
	if imBarrage and CoolDown == false:
		$Node2D / ColorRect2.rect_size.y = ((50.0 - General.arm_barrage_count) * 2 * 0.01) * 39.0
	

	if $Node2D / AnimationPlayer.current_animation.find("KD") != - 1: CoolDown = true
	
	
	if General.stands_panel_activate == true:
		yield(get_tree().create_timer(0.05), "timeout")
		if General.stands_panel_activate == false:
			imBarrage = false
			imBeatDown = false
		
	if General.current_support["Name"] == "Pucci" and General.stand_number != 19:
		speed_boost = 1.5
	elif General.current_support["Name"] == "Pucci" and General.stand_number == 19:
		speed_boost = 2.5
	elif General.stand_number == 19:
		speed_boost = 2
	else:
		speed_boost = 1
	if (General.enemy_health <= 0 or General.heart_points <= 0) and get_tree().current_scene.name != "TrainingArena":
		barrage_end()
	
	
	if is_timer_active(bubble_beyound_timer) and General.attacked and General.bubble_bey_stop == false and (General.stand_number == 10 and attack_id == 2):
		_on_DopButton_released()
		pressed_activate = true
	
	if General.player_block_all:
		$Node2D / AnimationPlayer.playback_speed = 0 * speed_boost
	else:
		if General.kd_end == false:
			$Node2D / AnimationPlayer.playback_speed = 1 * speed_boost
		else:
			if (attack_id == 2 and General.stand_number == 1) or (attack_id == 1 and General.stand_number == 2) or (attack_id == 1 and General.stand_number == 8):
				while General.time_stop or General.time_erase:
					yield(get_tree().create_timer(0.1), "timeout")
			$Node2D / AnimationPlayer.playback_speed = 99999 * speed_boost
			yield($Node2D / AnimationPlayer, "animation_finished")
			$Node2D / AnimationPlayer.playback_speed = 1 * speed_boost
			General.kd_end = false
	
	
	if is_timer_active(barrage_timer):
		General.barrage_activate = true
	
	if pressed_activate or CoolDown:
		$Sprite.modulate = Color("828282")
	else:
		$Sprite.modulate = Color("ffffff")
	
	
	if imBeatDown:
		$Node2D / ColorRect2.rect_size.y = (General.BeatDownCharge / 300.0) * 39.0
		if General.BeatDownCharge < 300:
			CoolDown = true
		else:
			CoolDown = false
	
	if General.arm_barrage_count >= 50:
		if General.barrage_activate and imBarrage:
			barrage_end()
	var FrameBut = - 1
	match General.stand_number:
		1: match attack_id:
				1: FrameBut = 1
				2: FrameBut = 4
				3: FrameBut = 7
		2: match attack_id:
				1: FrameBut = 7
				2: FrameBut = 4
				3: FrameBut = 16
		3: match attack_id:
				1: FrameBut = 0
				2: FrameBut = 7
				3: FrameBut = 15
		4: match attack_id:
				1: FrameBut = 2
				2: FrameBut = 11
		5: match attack_id:
				1: FrameBut = 2
				2: FrameBut = 8
				3: FrameBut = 11
		6: match attack_id:
				1: FrameBut = 6
				2: FrameBut = 7
		8: match attack_id:
				1: FrameBut = 3
				2: FrameBut = 5
				3: FrameBut = 12
		9: match attack_id:
				1: FrameBut = 2
				2: FrameBut = 13
				3: FrameBut = 14
				4: FrameBut = 20
		10: match attack_id:
				1: FrameBut = 9
				2: FrameBut = 10
				3: FrameBut = 7
		11: match attack_id:
				1: FrameBut = 2
				2: FrameBut = 20
				3: FrameBut = 14
				4: FrameBut = 23
				5: FrameBut = 7
				6: FrameBut = 21
				7:
					FrameBut = 22
					imBeatDown = true
		13: match attack_id:
				1: FrameBut = 3
				2: FrameBut = 12
		14: match attack_id:
				1: FrameBut = 1
				2: FrameBut = 4
		16: match attack_id:
				1: FrameBut = 0
				2: FrameBut = 4
				3: FrameBut = 8
				4: FrameBut = 1
				5: FrameBut = 14
				6: FrameBut = 7
		17: match attack_id:
				1: FrameBut = 0
				2: FrameBut = 7
				3: FrameBut = 15
		18: match attack_id:
				1: FrameBut = 17
				2: FrameBut = 7
				3: FrameBut = 18
		19: match attack_id:
				1: FrameBut = 17
				2: FrameBut = 7
				3: FrameBut = 19
		20: match attack_id:
				1: FrameBut = 7
				2: FrameBut = 24
				3: FrameBut = 30
		22: match attack_id:
				1: FrameBut = 7
				2: FrameBut = 25
				3: FrameBut = 26
				4: FrameBut = 29
		23: match attack_id:
				1: FrameBut = 7
				2: FrameBut = 1
				3: FrameBut = 27
				4: FrameBut = 5
				5:
					FrameBut = 28
					imBeatDown = true
		24: match attack_id:
				1: FrameBut = 0
				2: FrameBut = 7
				3: FrameBut = 31
				4: FrameBut = 32
				5: FrameBut = 33
				6:
					FrameBut = 34
					imBeatDown = true
		25: match attack_id:
				1: FrameBut = 7
				2: FrameBut = 30
				3: FrameBut = 35
		26: match attack_id:
				1: FrameBut = 7
				2: FrameBut = 36
				3: FrameBut = 37
				4:
					FrameBut = 38
					imBeatDown = true
		27: match attack_id:
				1: FrameBut = 7
				2: FrameBut = 39
				3: FrameBut = 40
	if FrameBut != - 1:
		$Sprite.frame = FrameBut
		visible = true
	else:
		visible = false
	
	if attack_id == 3 and (General.stand_number == 3 or General.stand_number == 16):
		if $Node2D / AnimationPlayer.current_animation != "":
			General.metka_tree_enabled = false
		else:
			General.metka_tree_enabled = true
	
	if pressed_activate and attack_started == false:
		pass
		
	
	if is_timer_active(bubble_beyound_timer) and General.bubble_bey_stop == false and General.attacked and (General.stand_number == 10 and attack_id == 2):
		bubble_beyound_end()
	
	if General.barrage_activate and General.attacked and ((General.stand_number == 3 and attack_id == 2) or (General.stand_number == 1 and attack_id == 3) or (General.stand_number == 10 and attack_id == 3) or (General.stand_number == 6 and attack_id == 2) or (General.stand_number == 2 and attack_id == 2) or (General.stand_number == 16 and attack_id == 6)):
		attack_started = false
		General.barrage_activate = false
		if is_instance_valid(barrage_timer):
			time_last = barrage_timer.time_left
			barrage_timer.stop()
	
func _on_DopButton_pressed():
	if (General.stable.find("hide")) == - 1 or General.debuff_enemy == "HgZahvat" != true:
		pressed_activate = true
		var player
		if get_tree().current_scene.name != "MorioMap":
			player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
		elif get_tree().current_scene.name == "MorioMap":
			player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
		
		
		if not CoolDown and General.stands_panel_activate == false and General.stand_activate_activated == false and General.barrage_activate == false and General.dostup_combo and General.player_block_attack == false:
			if imBeatDown:
				General.BeatDownCharge = 0
			
			match General.stand_number:
				2:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false:
								attack_started = true
								var enemy = get_node("/root/" + get_tree().current_scene.name + "/YSorting/Enemy")
								connect("enemy_timer_timestop_sp", enemy, "enemy_timer_timestop_sp")
								emit_signal("enemy_timer_timestop_sp")
								disconnect("enemy_timer_timestop_sp", enemy, "enemy_timer_timestop_sp")
								General.time_stop = true
								connect("za_warudo_sp", player, "za_warudo_sp")
								emit_signal("za_warudo_sp")
								disconnect("za_warudo_sp", player, "za_warudo_sp")
								first_attack_kd()
								yield(get_tree().create_timer(9), "timeout")
								General.time_stop = false
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("StarFinger")
								three_attack_kd()

				25:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("revolver")
								CoolDown(15)
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("d4cHIDE")
								CoolDown(15)

				26:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("WoU_defence")
								CoolDown(20)
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("WoU_NoLucky")
								CoolDown(20)
						4:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("WoU_bd")

				20:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("ws_disc")
								CoolDown(15)
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("revolver")
								CoolDown(15)
				22:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("CMoonEver")
								CoolDown(20)
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("GravityRight")
								CoolDown(20)
						4:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("C-Moon_Jump")
								CoolDown(20)
				23:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								knife_count -= 1
								General.count_attacks += 1
								connect("knife_tw_go", player, "knife_tw")
								emit_signal("knife_tw_go")
								disconnect("knife_tw_go", player, "knife_tw")
								if knife_count == 0:
									CoolDown(15)
									knife_count = 3
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								General.mih_speed = 3
								player.SoundPlay("res://Music/MIHboost.mp3")
								CoolDown(20)
						4:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("MIHchop")
								CoolDown(20)
						5:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								CoolDown(70)
								get_node("/root/" + get_tree().current_scene.name + "/CanvasModulate/AnimationPlayer").play("MIH")
								get_node("/root/" + get_tree().current_scene.name + "/CanvasModulate/AnimationPlayer").playback_speed = 0.2
								for i in 128:
									yield(get_tree().create_timer(0.1), "timeout")
									get_node("/root/" + get_tree().current_scene.name + "/CanvasModulate/AnimationPlayer").playback_speed += 0.5
								yield(get_tree().create_timer(0.1), "timeout")

								
								var da = Light2D.new()
								da.texture = load("res://Textures/Light.png")
								da.texture_scale = 16
								da.energy = 0
								
								get_node("/root/" + get_tree().current_scene.name).add_child(da)
								da.global_position = General.player_pos
								for i in 80:
									da.energy += 0.2
									yield(get_tree().create_timer(0.02), "timeout")
								get_node("/root/" + get_tree().current_scene.name + "/CanvasModulate/AnimationPlayer").playback_speed = 0
								get_node("/root/" + get_tree().current_scene.name + "/CanvasModulate/AnimationPlayer").play("PostMIH")
								da.mode = Light2D.MODE_ADD
								for i in 16:
									da.energy -= 1
									yield(get_tree().create_timer(0.05), "timeout")
								get_node("/root/" + get_tree().current_scene.name + "/YSorting/Enemy").health -= 75

				3:
					match attack_id:
						1:
							if General.heart_points < General.hp_max:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
									attack_started = true
									connect("health_ge_up", player, "health_up_ge_activate")
									emit_signal("health_ge_up")
									disconnect("health_ge_up", player, "health_up_ge_activate")
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									imBarrage = true
									player.BarrageAttack()
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								General.metka_tree_enabled = false
								connect("ge_tree_spawn", player, "ge_tree_spawn")
								emit_signal("ge_tree_spawn")
								disconnect("ge_tree_spawn", player, "ge_tree_spawn")
								three_attack_kd()
								General.metka_tree_enabled = true
				24:
					match attack_id:
						1:
							if General.heart_points < General.hp_max:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
									attack_started = true
									connect("health_ge_up", player, "health_up_ger_activate")
									emit_signal("health_ge_up")
									disconnect("health_ge_up", player, "health_up_ger_activate")
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									imBarrage = true
									player.BarrageAttack()
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								player.Attack("Scorpio")
								CoolDown(15)
						4:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								player.Attack("GERstone")
								CoolDown(15)
						5:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("GERzero")
								CoolDown(20)
						6:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								player.Attack("GERstart")
								CoolDown(1)
				1:
					match attack_id:
			
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								knife_count -= 1
								General.count_attacks += 1
								connect("knife_tw_go", player, "knife_tw")
								emit_signal("knife_tw_go")
								disconnect("knife_tw_go", player, "knife_tw")
								if knife_count == 0:
									first_attack_kd()
									knife_count = 3
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false:
								attack_started = true
								var enemy = get_node("/root/" + get_tree().current_scene.name + "/YSorting/Enemy")
								connect("enemy_timer_timestop_tw", enemy, "enemy_timer_timestop_tw")
								emit_signal("enemy_timer_timestop_tw")
								disconnect("enemy_timer_timestop_tw", enemy, "enemy_timer_timestop_tw")
								General.time_stop = true
								connect("za_warudo_tw", player, "za_warudo_tw")
								emit_signal("za_warudo_tw")
								disconnect("za_warudo_tw", player, "za_warudo_tw")
								second_attack_kd()
								yield(get_tree().create_timer(13), "timeout")
								General.time_stop = false
						
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
				8:
					match attack_id:
			
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false:
								attack_started = true
								General.enemy_time_scale = 0.1
								General.time_erase = true
								first_attack_kd()
								connect("time_erase_kc", player, "time_erase_kc")
								emit_signal("time_erase_kc")
								disconnect("time_erase_kc", player, "time_erase_kc")
								yield(get_tree().create_timer(7.5), "timeout")
								if General.time_erase:
									yield(get_tree().create_timer(0.5), "timeout")
									General.enemy_time_scale = 1
									General.time_erase = false
							
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.dostup_combo and General.stand_activate_activated == false and General.barrage_activate == false:
								attack_started = true
								General.count_attacks += 1
								player.Attack("ChopKC")
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and epit_count >= 1 and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								epit_count -= 1
								General.epitafia_enabled = true
								connect("epit_kc_go", player, "epitafia_vfx_spawn")
								emit_signal("epit_kc_go")
								disconnect("epit_kc_go", player, "epitafia_vfx_spawn")
								var effect = epitafia_effect.instance()
								get_parent().get_parent().get_parent().add_child(effect)
								if epit_count == 0:
									three_attack_kd()
									epit_count = 2
								else:
									yield(get_tree().create_timer(9.5), "timeout")
									if General.epitafia_enabled:
										yield(get_tree().create_timer(0.5), "timeout")
										General.epitafia_enabled = false
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
				13:
					match attack_id:
			
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false:
								attack_started = true
								General.enemy_time_scale = 0.1
								General.time_erase = true
								first_attack_kd()
								connect("time_erase_kc", player, "time_erase_kc")
								emit_signal("time_erase_kc")
								disconnect("time_erase_kc", player, "time_erase_kc")
								yield(get_tree().create_timer(7.5), "timeout")
								if General.time_erase:
									yield(get_tree().create_timer(0.5), "timeout")
									General.enemy_time_scale = 1
									General.time_erase = false
							
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								General.epitafia_enabled = true
								connect("epit_kc_go", player, "epitafia_vfx_spawn")
								emit_signal("epit_kc_go")
								disconnect("epit_kc_go", player, "epitafia_vfx_spawn")
								var effect = epitafia_effect.instance()
								get_parent().get_parent().get_parent().add_child(effect)
								three_attack_kd()
								yield(get_tree().create_timer(9.5), "timeout")
								if General.epitafia_enabled:
									yield(get_tree().create_timer(0.5), "timeout")
									General.epitafia_enabled = false
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
				4:
					match attack_id:
			
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								CoolDown(10)
								connect("tea_go", player, "tea_go")
								emit_signal("tea_go")
								disconnect("tea_go", player, "tea_go")
						
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								if General.nail_count.count(1) > 0:
									attack_started = true
									CoolDown(10)
									General.player_block_all = true
									player.Attack("TripleNails")
									General.player_block_all = false
				5:
					match attack_id:
			
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								connect("tea_go", player, "tea_go")
								emit_signal("tea_go")
								disconnect("tea_go", player, "tea_go")
								CoolDown(10)
						
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.nail_count.size() > 0 and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								CoolDown(15)
								connect("tusk2_hole_go", player, "tusk2_hole_go")
								emit_signal("tusk2_hole_go")
								disconnect("tusk2_hole_go", player, "tusk2_hole_go")
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								if General.nail_count.count(1) > 0:
									attack_started = true
									CoolDown(15)
									General.player_block_all = true
									player.Attack("TripleNails")
									General.player_block_all = false
				9:
					match attack_id:
			
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								CoolDown(10)
								connect("tea_go", player, "tea_go")
								emit_signal("tea_go")
								disconnect("tea_go", player, "tea_go")
						
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								if General.nail_count.count(1) > 0:
									attack_started = true
									CoolDown(15)
									General.player_block_all = true
									connect("tusk_3_hole_go", player, "tusk_3_hole_go")
									emit_signal("tusk_3_hole_go")
									disconnect("tusk_3_hole_go", player, "tusk_3_hole_go")
									General.player_block_all = false
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								if General.nail_count.count(1) > 0:
									attack_started = true
									player.Attack("TuskAct3bd")
									CoolDown(15)
						4:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								player.Attack("TuskHoleSave")
								CoolDown(15)
				11:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								connect("tea_go", player, "tea_go")
								emit_signal("tea_go")
								disconnect("tea_go", player, "tea_go")
								CoolDown(20)
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								CoolDown(20)
								player.Attack("TuskHoleSave")
						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								if General.nail_count.count(1) > 0:
									attack_started = true
									quadra_attack_kd()
									player.Attack("TuskAct3bd")
									CoolDown(40)
						4:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								attack_started = true
								CoolDown(25)
								connect("johny_awakening_go", player, "johny_awakening_go")
								emit_signal("johny_awakening_go")
								disconnect("johny_awakening_go", player, "johny_awakening_go")
						5:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									imBarrage = true
									player.BarrageAttack()
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
						6:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								if General.nail_count.count(1) > 0:
									attack_started = true
									player.Attack("GoldNailDa")
									CoolDown(25)
						7:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
									attack_started = true
									player.Attack("InfinitySpinEnemy")
				6:
					match attack_id:
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								player.Attack("EchoesGlush")
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
				10:
					match attack_id:

						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.is_bubble_beyound_activate == false:
								attack_started = true
								General.count_attacks += 1
								connect("bubble_saw_go", player, "bubble_saw")
								emit_signal("bubble_saw_go")
								disconnect("bubble_saw_go", player, "bubble_saw")
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						
						2:
							if ($Node2D / AnimationPlayer.current_animation == "" or $Node2D / AnimationPlayer.current_animation == "KD_BubbleBeyound_S&W_Start") and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false and General.stand_activated:
								General.is_bubble_beyound_activate = true
								attack_started = true
								General.count_attacks += 1
								CoolDown(1)
								General.player_attack_activate = true
								connect("bubble_saw_go_bey_start", player, "go_beyond_bubble_saw_start")
								emit_signal("bubble_saw_go_bey_start")
								disconnect("bubble_saw_go_bey_start", player, "go_beyond_bubble_saw_start")
								bubble_beyound_timer.connect("timeout", self, "bubble_beyound_end")
								bubble_beyound_timer.wait_time = 0.95
								bubble_beyound_timer.one_shot = true
								bubble_beyound_timer.start()

						3:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.is_bubble_beyound_activate == false and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
				14:
					match attack_id:
			
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								knife_count -= 1
								General.count_attacks += 1
								connect("knife_tw_go", player, "knife_tw")
								emit_signal("knife_tw_go")
								disconnect("knife_tw_go", player, "knife_tw")
								if knife_count == 0:
									first_attack_kd()
									knife_count = 3
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false:
								attack_started = true
								var enemy = get_node("/root/" + get_tree().current_scene.name + "/YSorting/Enemy")
								connect("enemy_timer_timestop_shadowtw", enemy, "enemy_timer_timestop_shadowtw")
								emit_signal("enemy_timer_timestop_shadowtw")
								disconnect("enemy_timer_timestop_shadowtw", enemy, "enemy_timer_timestop_shadowtw")
								General.time_stop = true
								connect("shadow_tw_ts", player, "shadow_tw_ts")
								emit_signal("shadow_tw_ts")
								disconnect("shadow_tw_ts", player, "shadow_tw_ts")
								second_attack_kd()
								yield(get_tree().create_timer(9), "timeout")
								General.time_stop = false
				18, 19:
					match attack_id:
				
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								knife_count -= 1
								General.count_attacks += 1
								connect("weapon_scr_go", player, "weapon_scr")
								emit_signal("weapon_scr_go")
								disconnect("weapon_scr_go", player, "weapon_scr")
								first_attack_kd()
						3:
							if General.stand_activated == true and General.heart_points > 51:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
										attack_started = true
										connect("armor_scr_go", player, "armor_scr_func")
										emit_signal("armor_scr_go")
										disconnect("armor_scr_go", player, "armor_scr_func")
										first_attack_kd()
						
						2:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
				16:
					match attack_id:
						1:
							if General.heart_points < General.hp_max:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
									attack_started = true
									connect("overwrite_twoh_self", player, "overwrite_twoh_self_activ")
									emit_signal("overwrite_twoh_self")
									disconnect("overwrite_twoh_self", player, "overwrite_twoh_self_activ")
									CoolDown(20)
						2:
							if General.stand_activated == true:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false:
									attack_started = true
									var enemy = get_node("/root/" + get_tree().current_scene.name + "/YSorting/Enemy")
									connect("enemy_timer_timestop_twoh", enemy, "enemy_timer_timestop_twoh")
									emit_signal("enemy_timer_timestop_twoh")
									disconnect("enemy_timer_timestop_twoh", enemy, "enemy_timer_timestop_twoh")
									General.time_stop = true
									connect("ts_twoh", player, "ts_twoh")
									emit_signal("ts_twoh")
									disconnect("ts_twoh", player, "ts_twoh")
									second_attack_kd()
									yield(get_tree().create_timer(19), "timeout")
									General.time_stop = false
						3:
							if General.stand_activated == true:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
										attack_started = true
										connect("overwrite_twoh_enemy", player, "overwrite_twoh_enemy_activ")
										emit_signal("overwrite_twoh_enemy")
										disconnect("overwrite_twoh_enemy", player, "overwrite_twoh_enemy_activ")
										CoolDown(20)
						4:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.dostup_combo and General.barrage_activate == false:
								attack_started = true
								knife_twoh_count -= 1
								General.count_attacks += 1
								connect("knife_tw_go", player, "knife_tw")
								emit_signal("knife_tw_go")
								disconnect("knife_tw_go", player, "knife_tw")
								if knife_twoh_count == 0:
									quadra_attack_kd()
									knife_twoh_count = 3
								if General.max_default_attack_count == 3 and General.default_attack_count > 0:
									General.max_default_attack_count = 5
						5:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
								attack_started = true
								General.metka_tree_enabled = false
								connect("twoh_light_spawn", player, "twoh_light_spawn")
								emit_signal("twoh_light_spawn")
								disconnect("twoh_light_spawn", player, "twoh_light_spawn")
								penta_attack_kd()
						6:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
				27:
					match attack_id:
						3:
							if General.stand_activated == true:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false:
										attack_started = true
										connect("zahvat_hg_enemy", player, "zahvat_hg_enemy_activ")
										emit_signal("zahvat_hg_enemy")
										disconnect("ozahvat_hg_enemy", player, "zahvat_hg_enemy_activ")
										CoolDown(20)
						2:
							if General.stand_activated == true:
								if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.player_attack_activate == false and General.barrage_activate == false and General.stand_activated:
									attack_started = true
									player.Attack("emerald_splash")
									CoolDown(15)
						1:
							if $Node2D / AnimationPlayer.current_animation == "" and General.attacked == false and General.blocked == false and General.dashed == false and General.player_block_all == false and General.stand_activated and General.stand_activate_activated == false:
								if General.arm_barrage_count < 50:
									attack_started = true
									General.barrage_activate = true
									player.BarrageAttack()
									imBarrage = true
									if General.max_default_attack_count == 3 and General.default_attack_count > 0:
										General.max_default_attack_count = 5
	else:
		General.message_spawn("Center", "Вы не можете использовать способности")

func bubble_beyound_end():
	var player
	if get_tree().current_scene.name != "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
	elif get_tree().current_scene.name == "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	
	
	if is_instance_valid(bubble_beyound_timer):
		bubble_beyound_timer.stop()
	
	connect("bubble_saw_go_bey", player, "go_beyond_bubble_saw")
	emit_signal("bubble_saw_go_bey")
	disconnect("bubble_saw_go_bey", player, "go_beyond_bubble_saw")
	if General.max_default_attack_count == 3 and General.default_attack_count > 0:
		General.max_default_attack_count = 5
	if is_instance_valid(barrage_timer) and barrage_timer.is_stopped():
		General.player_attack_activate = false
	General.is_bubble_beyound_activate = false
	General.bubble_go_beyound_start_activate = false
	yield(get_tree().create_timer(0.5), "timeout")
	BlackLinesVertical.end_lines()

func _on_DopButton_released():
	pressed_activate = false
	if General.barrage_activate and imBarrage:
		yield(get_tree().create_timer(0.3), "timeout")
		attack_started = false
		General.barrage_activate = false
	
	
	if is_instance_valid(bubble_beyound_timer) and is_timer_active(bubble_beyound_timer):
		attack_started = false
		var player
		if get_tree().current_scene.name != "MorioMap":
			player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
		elif get_tree().current_scene.name == "MorioMap":
			player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
		
		bubble_beyound_timer.stop()
		General.bubble_bey_stop = true
		General.is_bubble_beyound_activate = false
		if $Node2D / AnimationPlayer.current_animation == "KD_BubbleBeyound_S&W_Start":
			CoolDown(1)
		if is_instance_valid(barrage_timer) and barrage_timer.is_stopped():
			General.player_attack_activate = false
		yield(get_tree().create_timer(0.5), "timeout")
		BlackLinesVertical.end_lines()

func barrage_end():
	General.barrage_activate = false
	barrage_timer_will_end = true
	
	if imBarrage:
		match General.stand_number:
			1, 2, 3, 6, 10, 16, 18:
				CoolDown(30)
			_:
				CoolDown(15)
	General.arm_barrage_count = 0

func first_attack_kd():
	attack_started = false
	match General.stand_number:
		1, 14: $Node2D / AnimationPlayer.play("KD_Knife_TW")
		2: $Node2D / AnimationPlayer.play("KD_TimeStop_SP")
		3, 17: $Node2D / AnimationPlayer.play("KD_Health_GE")
		4: $Node2D / AnimationPlayer.play("KD_Tea_T1")
		5: $Node2D / AnimationPlayer.play("KD_Tea_T2")
		9: $Node2D / AnimationPlayer.play("KD_Tea_T3")
		11: $Node2D / AnimationPlayer.play("KD_Tea_T4")
		6: $Node2D / AnimationPlayer.play("KD_Glush_E1")
		8, 13: $Node2D / AnimationPlayer.play("KD_TimeErase_KC")
		10: $Node2D / AnimationPlayer.play("KD_BubbleEyes_S&W")
		16: $Node2D / AnimationPlayer.play("KD_HP_TWOH")
		18, 19: $Node2D / AnimationPlayer.play("KD_Armor")

func second_attack_kd():
	attack_started = false
	match General.stand_number:
		1, 14: CoolDown(30)
		3: $Node2D / AnimationPlayer.play("KD_Barrage_GE")
		4: $Node2D / AnimationPlayer.play("KD_SpinNail_T1")
		5: $Node2D / AnimationPlayer.play("KD_Hole_T2")
		8: $Node2D / AnimationPlayer.play("KD_Chop_KC")
		9: $Node2D / AnimationPlayer.play("KD_Hole_T3")
		11: $Node2D / AnimationPlayer.play("KD_Hole_T4")
		10: CoolDown(40)
		16: $Node2D / AnimationPlayer.play("KD_TWOH_TS")
		18, 19: $Node2D / AnimationPlayer.play("KD_Barrage_SCR")

func three_attack_kd():
	attack_started = false
	match General.stand_number:
		2: $Node2D / AnimationPlayer.play("KD_StarFinger_SP")
		3, 17: $Node2D / AnimationPlayer.play("KD_Tree_GE")
		11: $Node2D / AnimationPlayer.play("KD_T4_Awakening")
		5: $Node2D / AnimationPlayer.play("KD_SpinNail_T2")
		8, 13: $Node2D / AnimationPlayer.play("KD_Epitafia_KC")
		9: $Node2D / AnimationPlayer.play("KD_SpinNail_T3")
		16: $Node2D / AnimationPlayer.play("kD_OVERWRITE_TWOH")
		18, 19: $Node2D / AnimationPlayer.play("KD_Disweapon")
		
func quadra_attack_kd():
	match General.stand_number:
		11: $Node2D / AnimationPlayer.play("Mini_bd_T4")
		16: $Node2D / AnimationPlayer.play("KD_KNIFE_TWOH")
		
func penta_attack_kd():
	match General.stand_number:
		11: $Node2D / AnimationPlayer.play("Kd_Counter_T4")
		16: $Node2D / AnimationPlayer.play("KD_Twoh_Light")
		
func bd_attack_kd():
	if General.stand_number == 11:
		pass
		
func black_lines():
	BlackLinesVertical.start_lines()

func CoolDown(sec: float):
	var CurrentID = int(rand_range( - 500, 500))
	CoolDownId = CurrentID
	$Node2D / AnimationPlayer.stop()
	$Node2D / ColorRect2.rect_size.y = 0
	$Sprite.modulate = Color("828282")
	CoolDown = true
	for i in int(sec * 20):
		
		yield(get_tree().create_timer(0.05), "timeout")
		if CoolDownId == CurrentID:
			$Node2D / ColorRect2.rect_size.y += 39 / float(int(sec * 20))
		else:
			return
	$Sprite.modulate = Color("ffffff")
	$Node2D / ColorRect2.rect_size.y = 39
	CoolDown = false
	$Sprite.scale = Vector2(0.75, 0.75)
	yield(get_tree().create_timer(0.05), "timeout")
	for i in 3:
		$Sprite.scale += Vector2(0.09, 0.09)
		yield(get_tree().create_timer(0.05), "timeout")
	$Sprite.scale = Vector2(0.95, 0.95)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name.find("KD") != - 1:
		CoolDown = false
	
	$Sprite.scale = Vector2(0.75, 0.75)
	yield(get_tree().create_timer(0.05), "timeout")
	for i in 3:
		$Sprite.scale += Vector2(0.09, 0.09)
		yield(get_tree().create_timer(0.05), "timeout")
	$Sprite.scale = Vector2(0.95, 0.95)
