# GGPlayer.gd — игрок сцены: узлы, сигналы и делегирование сервисам.
#
# Наследует PlayerEntity. Здесь остаются связи со сценой, ввод и небольшие
# UI/диалоговые вызовы; боевые, физические и анимационные детали — в
# Systems/Player*Service.gd.
#
# Моддинг: новые атаки — в AttackService/BulletAttackService, поведение
# предметов — в ItemUseService. Добавляя onready-узел, обновите .tscn.

extends "res://NewClasses/PlayerEntity.gd"

const StandAbilityScript = preload("res://NewClasses/Abilities/StandAbility.gd")
const TechnicAbilityScript = preload("res://NewClasses/Abilities/TechnicAbility.gd")
const SpecAbilityScript = preload("res://NewClasses/Abilities/SpecAbility.gd")

var stand_ability = null
var technic_ability = null
var spec_ability = null
var item_use_service = preload("res://Systems/ItemUseService.gd").new()
var dialog_service = preload("res://Systems/DialogService.gd").new()
var bullet_attack_service = preload("res://Systems/BulletAttackService.gd").new()
var attack_service = preload("res://Systems/AttackService.gd").new()
var dash_service = preload("res://Systems/DashService.gd").new()
var item_box_service = preload("res://Systems/ItemBoxService.gd").new()
var player_process_service = preload("res://Systems/PlayerProcessService.gd").new()
var player_physics_service = preload("res://Systems/PlayerPhysicsService.gd").new()
var combat_control_service = preload("res://Systems/PlayerCombatControlService.gd").new()
var combat_action_service = preload("res://Systems/PlayerCombatActionService.gd").new()
var ability_action_service = preload("res://Systems/PlayerAbilityActionService.gd").new()
var animation_service = preload("res://Systems/PlayerAnimationService.gd").new()
var stand_area_service = preload("res://Systems/PlayerStandAreaService.gd").new()
var cutscene_service = preload("res://Systems/PlayerCutsceneService.gd").new()

# Публичные методы ниже — тонкие обёртки; логика находится в сервисах.

onready var cam_player = $YSort / Camera2D
onready var stand = $YSort / Stand
onready var anim_stand: AnimationPlayer = $YSort / Stand / StandAnimation
onready var MoveAnimStand = $YSort / Stand / StandMoveAnim
onready var stand_sprite = $YSort / Stand / Stand_Texture
onready var stand_area_attack = $YSort / Stand / StandArea
onready var arm_item = $YSort / Node2D
onready var stand_particles = preload("res://Scenes/StandEffect.tscn")
onready var bullet_spawn = preload("res://Scenes/BulletAttack.tscn")
onready var vfx_nail_tusk_spawn = preload("res://Scenes/TuskNailVFX.tscn")
onready var vfx_health_up = preload("res://Scenes/HealthUpParticles.tscn")
onready var vfx_spin_defense = preload("res://Scenes/SpinDefenseParticle.tscn")
onready var vfx_level_up = preload("res://Scenes/LvlUpParticles.tscn")
onready var vfx_spin_up = preload("res://Scenes/SpinVFXFirst.tscn")
onready var vfx_arrow_activate = preload("res://Scenes/ArrowActivate.tscn")
onready var disc_vfx = preload("res://Scenes/DiscActivateFullVFX.tscn")
var random = RandomNumberGenerator.new()
var collision_npc = Vector2(false, 0)
var attemp_lesson_spin_count = 0
var true_spin_count = 0
var false_spin_count = 0
var random_spin_timer = [0.25, 0.35, 0.45, 0.55, 0.65, 0.75]
var nail_no_zero = General.nail_count.duplicate()
var position_first = Vector2.ZERO
var dash_kuldown = Timer.new()
var health_timer = Timer.new()
var barrage_arm = preload("res://Scenes/BarrageArm.tscn")
var spinball_spawn = preload("res://Scenes/SpinBall.tscn")
var laser_spawn = preload("res://Scenes/LaserBullet.tscn")
var goldball_spawns = preload("res://Scenes/SpinGoldBall.tscn")
var bubble_beyound_start = preload("res://Scenes/BubbleBulletStart.tscn")

# Смещения до границ арены; DashService читает у них .x/.y.
var dist_l = Vector2.ZERO
var dist_r = Vector2.ZERO
var dist_t = Vector2.ZERO
var dist_b = Vector2.ZERO
var dist_enemy_l = General.enemy_position - General.left_block_position
var dist_enemy_r = General.right_block_position - General.enemy_position
var dist_enemy_t = General.enemy_position - General.top_block_position
var dist_enemy_b = General.bottom_block_positon - General.enemy_position

var tusk_3_hole_position = Vector2.ZERO
var tusk_4_hole_position = Vector2.ZERO
var tusk_4_hole_position_2 = Vector2.ZERO
signal knife_attacked
signal enemy_attacked
signal chop_end
signal first_attack_kd
signal second_attack_kd
signal bd_attack_kd
signal kd_dash_start
signal technic_attack_kd
signal attack_kd_start
signal enemy_timer_start


var tree_ge = preload("res://Scenes/GeTree.tscn")
var twoh_light = preload("res://Scenes/TWOHLight.tscn")
var stand_activate_activated = false
var check = 0
var time_passed = 0.0
var jesus_timer = 0.0
var black_hole_bullet = preload("res://Scenes/BlackHoleBullet.tscn")
var vfx_epitafia = preload("res://Scenes/EpitafiaKingCrimsonVFX.tscn")
var vfx_johny_awaken = preload("res://Scenes/JohnyAwakenVfx.tscn")
var echoes_nail_arm = preload("res://Scenes/EchoesAct1Nails.tscn")
var tusk_3_hole = preload("res://Scenes/Tusk3Hole.tscn")
var tusk_4_hole = preload("res://Scenes/Tusk4Hole.tscn")
var fear_count = 0
var addition = []
var Timers = {}
var Cast = 0.0

func _ensure_child_timer(t: Timer) -> void :
	if t == null:
		return
	if t.get_parent() != self:
		if t.get_parent():
			t.get_parent().remove_child(t)
		add_child(t)

func _disconnect_player_timers() -> void :
	var methods = ["do_this", "time_health_up"]
	for child in get_children():
		if child is Timer:
			child.stop()
			for method in methods:
				if child.is_connected("timeout", self, method):
					child.disconnect("timeout", self, method)
	if dash_kuldown.is_connected("timeout", self, "do_this"):
		dash_kuldown.disconnect("timeout", self, "do_this")
	if health_timer.is_connected("timeout", self, "time_health_up"):
		health_timer.disconnect("timeout", self, "time_health_up")

func _exit_tree() -> void :
	_disconnect_player_timers()
	_release_general_timer_spin()
	General.release_player_refs(self)

func _release_general_timer_spin() -> void :
	if General.timer_spin.get_parent() == self:
		if General.timer_spin.is_connected("timeout", self, "false_lesson_timer_end"):
			General.timer_spin.disconnect("timeout", self, "false_lesson_timer_end")
		# Возвращаем общий таймер General, а не оставляем его без родителя.
		General.timer_service.park_timer(General, General.timer_spin)

func _process(delta: float):
	._process(delta)
	player_process_service.process(self, delta)


func _setup_abilities():
	stand_ability = StandAbilityScript.new()
	stand_ability.name = "StandAbility"
	add_child(stand_ability)
	stand_ability.setup(self, General.content_db())
	stand_ability.set_stand(General.stand_number)

	technic_ability = TechnicAbilityScript.new()
	technic_ability.name = "TechnicAbility"
	add_child(technic_ability)
	technic_ability.setup(self, General.content_db())
	technic_ability.set_technic(General.techic_number)

	spec_ability = SpecAbilityScript.new()
	spec_ability.name = "SpecAbility"
	add_child(spec_ability)
	spec_ability.setup(self, General.content_db())
	spec_ability.set_race(General.race_number)


func _ready():
	._ready()
	# Эти таймеры созданы в начале файла. Добавляем их в дерево сразу, чтобы
	# при удалении игрока они освобождались вместе с ним, а не оставались
	# осиротевшими объектами Timer.
	_ensure_child_timer(dash_kuldown)
	_ensure_child_timer(health_timer)
	_setup_abilities()
	for i in [$YSort / Texture / Equips / CyborgModifedEquip, $YSort / Texture / Equips / CyborgModifedEquip2, $YSort / Texture / Equips / CyborgModifedEquip3, $YSort / Texture / Equips / CyborgModifedEquip4, $YSort / Texture / Equips / CyborgModifedEquip5]:
		i.visible = false
	
	General.GGPlayer = self
	General.regen_hp_timer()
	General.nail_count = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	$ItemBox / CollisionShape2D.set_deferred("disabled", false)
	General.default_attack_count = 0
	General.stand_activated = false
	if General.player_direct == "right":
		scale.x *= - 1
	random.randomize()
	if General.is_tournir == false:
		reset_health()
	else:
		pass
	General.damage_for_player_counts = 0
	General.damage_for_enemy_counts = 0
	General.popadania = 0
	General.count_attacks = 0
	# block_glush принадлежит General и уже добавлен в дерево в _ready().
	if General.fast_pos_change == false:
		General.sync_player_pos_from_node(self)
		General.stand_pos = stand.global_position
	if General.is_saves_load == false and get_tree().current_scene.name != "TrainingArena":
		General.load_save()
	if General.check_array(3) != - 1:
		General.delete_item(3)
	if General.check_array(8) != - 1:
		General.delete_item(8)
	if General.player_pos_save != Vector2.ZERO and ((get_tree().current_scene.name in ["MorioMap", "Desert", "Jail", "Italy", "Rom", "Germany"]) or General.WasInArena) and General.fast_pos_change == false:
		General.apply_saved_player_position(self)
	General.WasInArena = false
		
	if get_tree().current_scene.name.find("DefaultEnemyArena") != - 1:
		General.nail_count = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		nail_no_zero = General.nail_count.duplicate()
		reset_health()
	if General.camera_speed != 10:
		cam_player.smoothing_enabled = true
		cam_player.smoothing_speed = General.camera_speed
	else:
		cam_player.smoothing_enabled = false
	if General.race_number == 5:
		spec_ability.apply_cyborg_battery(General)
				

func _physics_process(delta):
	player_physics_service.process(self, delta)


func item_activate_slot(slot_id):
	item_use_service.activate(self, slot_id)


func false_lesson_timer_end():
	General.timer_service.park_timer(General, General.timer_spin)
	false_spin_count = 0
	attemp_lesson_spin_count = 0
	true_spin_count = 0
	General.mini_game_first_number = 0
	General.mini_game_second_number = 0

func stand_activate():
	if stand_ability != null:
		stand_ability.stand_activate()
func _on_StandAnimation_animation_finished(anim_name):
	if stand_ability != null:
		stand_ability.on_stand_animation_finished(anim_name)
func stand_attack_anim(anim_name):
	if stand_ability != null:
		stand_ability.stand_attack_anim(anim_name)
func barrage_start(anim_name):
	if stand_ability != null:
		stand_ability.barrage_start(anim_name)
func move_stand_anim():
	if stand_ability != null:
		stand_ability.move_stand_anim()
func stand_animation():
	if stand_ability != null:
		stand_ability.stand_animation()
func _on_Area2D_area_entered(area):
	if area.is_in_group("YSortGroup"):
		General.player_on_ysort_area = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("YSortGroup"):
		General.player_on_ysort_area = false

func _on_ItemBox_area_entered(area):
	item_box_service.handle_entered(self, area)


func _on_ItemBox_area_exited(area):
	item_box_service.handle_exited(self, area)


func attack_bullet(attack_type):
	bullet_attack_service.attack(self, attack_type)


func on_stand_activate():
	if General.stand_index != "None" and (anim_stand.current_animation.find("Idle") != - 1 or anim_stand.current_animation.find("Move") != - 1) and anim_stand.current_animation.find("_Mid") == - 1 and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		stand_activate()

func on_attack_activate():
	combat_control_service.on_attack_activate(self)

func on_item_activate():
	if General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		item_activate_slot(General.item_in_arm)

func dialog_create(ans1, ans2, ans3, ans4, ans5, text, name, eng_name):
	General.dialog_create_signal = true
	General.answer_1 = ans1
	General.answer_2 = ans2
	General.answer_3 = ans3
	General.answer_4 = ans4
	General.answer_5 = ans5
	General.text_dialog = text
	General.npc_name = name
	General.npc_eng_name = eng_name

func on_dialog_activate():
	dialog_service.start_dialog(self)


func jesus_dialog(stand):
	if stand == "Tusk":
		if General.search_id(2.2) != - 1 and General.jesus_dialog_complete == false:
			dialog_create("что?", "...", 0, 0, 0, General.dialogue_text("jesus_advice1"), "Странник", "Jesus")
			General.enemy_block_all = true
			General.player_block_all = true
		elif General.search_id(2.2) == - 1:
			dialog_create("...", 0, 0, 0, 0, General.dialogue_text("jesus_early"), "Странник", "Jesus")
			General.enemy_block_all = true
			General.player_block_all = true
		elif General.search_id(2.2) != - 1 and General.jesus_dialog_complete:
			dialog_create("...", 0, 0, 0, 0, General.dialogue_text("jesus_given"), "Странник", "Jesus")
			General.enemy_block_all = true
			General.player_block_all = true
	elif stand == "Twoh":
			dialog_create("...", 0, 0, 0, 0, General.dialogue_text("jesus_heaven"), "Странник", "Jesus")
			General.enemy_block_all = true
			General.player_block_all = true
func arrow_activated():
	
	pass
func nail_plus():
	if General.is_invent_show == false and General.nail_count.count(1) < 10:
		pass
func position_back():
	animation_service.position_back(self)

func _on_PlayerFightAnimations_animation_finished(anim_name):
	animation_service.on_fight_animation_finished(self, anim_name)

func povorot_check(check_on_direct: bool):
	animation_service.povorot_check(self, check_on_direct)

func _on_PlayerFightAnimations_animation_started(anim_name):
	animation_service.on_fight_animation_started(self, anim_name)
func preduprejenie_for_enemy_before_attack():
	combat_control_service.preduprejenie_for_enemy_before_attack(self)

func preduprejenie_for_enemy_before_bullet():
	combat_control_service.preduprejenie_for_enemy_before_bullet(self)

func dash(type):
	dash_service.execute(self, type)

func on_dash_activate():
	combat_control_service.on_dash_activate(self)

func _on_GhostDashEffect_timeout():
	animation_service.ghost_dash_timeout(self)

func block():
	combat_control_service.block(self)
func health_up_ge_activate():
	ability_action_service.health_up_ge_activate(self)

func health_up_ger_activate():
	ability_action_service.health_up_ger_activate(self)

func overwrite_twoh_self_activ():
	ability_action_service.overwrite_twoh_self_activ(self)

func johny_awakening_go():
	ability_action_service.johny_awakening_go(self)

func tea_go():
	ability_action_service.tea_go(self)

func _on_StandArea_area_entered(area):
	stand_area_service.on_stand_area_entered(self, area)


func time_health_up():
	animation_service.time_health_up(self)

func fear_animation():
	animation_service.fear_animation(self)

func end_anim_check():
	animation_service.end_anim_check(self)

func chop_attack_kc():
	combat_action_service.chop_attack_kc(self)

func overwrite_twoh_enemy_activ():
	combat_action_service.overwrite_twoh_enemy_activ(self)

func zahvat_hg_enemy_activ():
	combat_action_service.zahvat_hg_enemy_activ(self)

func barrage_ge_attack():
	combat_action_service.barrage_ge_attack(self)

func barrage_scretro_attack():
	combat_action_service.barrage_scretro_attack(self)

func _on_MiniGameEchoes0_pressed():
	if General.stand_number == 47 and get_tree().current_scene.name == "MorioMap" and General.dialog_activate == false and General.is_invent_show == false and General.quest_panel_activate == false and General.mini_game_activate == false and General.catscene_activated == false and General.player_block_all == false and General.attacked == false and General.dashed == false:
		Transition.change_scene("res://GeneralGameScenes/EchoesAct0MiniGame.tscn", "Black")
		General.capture_player_pos_save(self)
	

func barrage_arm_spawn():
	combat_action_service.barrage_arm_spawn(self)

func barrage_nail_spawn():
	combat_action_service.barrage_nail_spawn(self)

func attack_combo_dostup():
	combat_control_service.attack_combo_dostup(self)

func knife_tw():
	combat_action_service.knife_tw(self)

func armor_scr_func():
	ability_action_service.armor_scr_func(self)

func weapon_scr():
	combat_action_service.weapon_scr(self)

func tusk2_hole_go():
	combat_action_service.tusk2_hole_go(self)

func echoes_glush_go():
	combat_action_service.echoes_glush_go(self)

func start_dop_kooldown(attack_number_id: int):
	combat_control_service.start_dop_kooldown(self, attack_number_id)

func start_kd_default_attack(is_strength: bool):
	combat_control_service.start_kd_default_attack(self, is_strength)

func dash_start_kd():
	combat_control_service.dash_start_kd(self)
func spin_default_go():
	combat_action_service.spin_default_go(self)

func spin_infinity_go():
	combat_action_service.spin_infinity_go(self)

func laser_cyborg_go():
	combat_action_service.laser_cyborg_go(self)

func spin_inf_defense_go():
	combat_action_service.spin_inf_defense_go(self)

func spin_gyro_go():
	combat_action_service.spin_gyro_go(self)

func techinc_first_attack_start_kd():
	combat_control_service.techinc_first_attack_start_kd(self)

func on_attack_activate_big():
	combat_control_service.on_attack_activate_big(self)

func dash_attack_end():
	combat_control_service.dash_attack_end(self)

func bubble_saw():
	combat_action_service.bubble_saw(self)

func go_beyond_bubble_saw():
	combat_action_service.go_beyond_bubble_saw(self)

func go_beyond_bubble_saw_start():
	combat_action_service.go_beyond_bubble_saw_start(self)

func spin_nail_go():
	combat_action_service.spin_nail_go(self)

func _on_AttackArea_area_entered(area):
	stand_area_service.on_attack_area_entered(self, area)

func epitafia_damage():
	combat_action_service.epitafia_damage(self)

func epitafia_vfx_spawn():
	combat_action_service.epitafia_vfx_spawn(self)

func za_warudo_tw():
	combat_action_service.za_warudo_tw(self)

func ts_twoh():
	combat_action_service.ts_twoh(self)

func shadow_tw_ts():
	combat_action_service.shadow_tw_ts(self)

func za_warudo_sp():
	combat_action_service.za_warudo_sp(self)

func time_erase_kc():
	combat_action_service.time_erase_kc(self)

func barrage_tw_attack():
	combat_action_service.barrage_tw_attack(self)

func barrage_twoh_attack():
	combat_action_service.barrage_twoh_attack(self)

func barrage_sp_attack():
	combat_action_service.barrage_sp_attack(self)

func barrage_saw_attack():
	combat_action_service.barrage_saw_attack(self)

func barrage_e1_attack():
	combat_action_service.barrage_e1_attack(self)

func ge_tree_spawn():
	combat_action_service.ge_tree_spawn(self)

func ger_tree_spawn():
	combat_action_service.ger_tree_spawn(self)

func twoh_light_spawn():
	combat_action_service.twoh_light_spawn(self)

func tusk_3_hole_go():
	combat_action_service.tusk_3_hole_go(self)

func black_hole_save():
	combat_action_service.black_hole_save(self)

func tusk_3_bd_go():
	combat_action_service.tusk_3_bd_go(self)

func Attack(Attack):
	attack_service.execute(self, Attack)


func BarrageAttack():
	attack_service.barrage(self)


func tusk_4_bd_go():
	combat_action_service.tusk_4_bd_go(self)

func sp_starfinger_go():
	combat_action_service.sp_starfinger_go(self)

func BulletAttack(Bullet: int, DopData: Dictionary = {}):
	bullet_attack_service.bullet_attack(self, Bullet, DopData)


func _on_StandMoveAnim_animation_finished(anim_name):
	if stand_ability != null:
		stand_ability.on_stand_move_anim_finished(anim_name)
func StandHitBoxGroup(group: String, Remove: bool = false):
	if Remove:
		# remove_from_group() для отсутствующей группы печатает ошибку
		# движка, поэтому сначала проверяем membership.
		if $YSort / Stand / StandArea.is_in_group(group):
			$YSort / Stand / StandArea.remove_from_group(group)
	else:
		$YSort / Stand / StandArea.add_to_group(group)

func CutScene(CutSceneName: String):
	cutscene_service.cutscene(self, CutSceneName)
