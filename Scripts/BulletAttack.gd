# BulletAttack.gd — снаряд игрока: движение, попадание и VFX.
#
# Создаётся из Systems/BulletAttackService.gd. Параметры (урон, тип,
# направление) передаются в Bullet/DopData; не читайте глобальные поля без
# необходимости.

extends KinematicBody2D

var velocity = Vector2(0, 0)
var is_dop_attack_second = false
var is_dop_attack_three = false
var is_attack_strength
var type = 0
var bubble = false
var bubble_id = 0
export var speed = 1
var exit_timer: Timer = null
onready var random = RandomNumberGenerator.new()
onready var bubble_effect = preload("res://Scenes/BubbleEndEffect.tscn")
var DopData: Dictionary = {}


func _remove_group(group: String) -> void:
	# remove_from_group() для отсутствующей группы печатает ошибку движка.
	# Снаряд меняет боевые группы в зависимости от стенда, поэтому проверяем
	# membership перед удалением.
	if $Area2D.is_in_group(group):
		$Area2D.remove_from_group(group)

func _ready():
	# Таймер живёт ребёнком снаряда и освобождается вместе с ним. Создаём его
	# здесь, а не в сигнале выхода за экран: сигнал может прийти, пока снаряд
	# ещё добавляет дочерние узлы, и add_child() в этот момент не сработает.
	exit_timer = Timer.new()
	exit_timer.name = "ExitTimer"
	add_child(exit_timer)
	if (General.stand_number in [1, 16]) and General.time_stop:
		random.randomize()
		yield(get_tree().create_timer(0.01), "timeout")
		position.y += random.randi_range( - 7, 7)
	
	random.randomize()
	General.pre_bullet_direct = General.player_direct
	z_index = 1
	if type == 1:
		$Line2D.leng = 999
		for i in $Area2D.get_groups():
			_remove_group(i)
		$Area2D.add_to_group("GoldNailDa")
		var curve: Curve = Curve.new()
		curve.add_point(Vector2(0, 1))
		$Line2D.width_curve = curve
		$Line2D.texture = load("res://Textures/Details/TrailNail.png")
		$Line2D.texture_mode = Line2D.LINE_TEXTURE_TILE
		$Line2D.width = 10
		$Line2D.default_color = Color("ffffff")
		$Area2D.scale.x *= 5
		speed = 0

		yield(get_tree().create_timer(0.1), "timeout")
		speed = 4
		yield(get_tree().create_timer(0.8), "timeout")
		for i in 10:
			yield(get_tree().create_timer(0.05), "timeout")
			$Line2D.width -= 1
	elif type == 3:
		$Line2D.leng = 999
		for i in $Area2D.get_groups():
			_remove_group(i)
		$Area2D.add_to_group("GERstone")
		var curve: Curve = Curve.new()
		curve.add_point(Vector2(0, 1))
		$Line2D.width_curve = curve
		$Line2D.texture = load("res://Textures/Details/TrailNail.png")
		$Line2D.texture_mode = Line2D.LINE_TEXTURE_TILE
		$Line2D.width = 10
		$Line2D.default_color = Color("ffffff")
		$Area2D.scale.x *= 5
		speed = 0

		yield(get_tree().create_timer(0.1), "timeout")
		speed = 4
		yield(get_tree().create_timer(0.2), "timeout")
		for i in 10:
			yield(get_tree().create_timer(0.05), "timeout")
			$Line2D.width -= 1
	elif type == 2:
		$AnimationPlayer.play("RevolverBullet")
		$Line2D.leng = 9
		for i in $Area2D.get_groups():
			_remove_group(i)
		$Area2D.add_to_group("Bullet2")
	elif type == 4:


		z_index = 99
		speed = 0
		$AnimationPlayer.play("GatlingBullet")
		$Line2D.leng = 9
		for i in $Area2D.get_groups():
			_remove_group(i)
		$Area2D.add_to_group("Bullet4")
	elif General.stand_index == "TuskAct1" and is_dop_attack_three == false:
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
		$AnimationPlayer.play(General.stand_index + "Idle")
		_remove_group("Ehos1t1")
		_remove_group("KnifeTW")
		_remove_group("Ehos1t2")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t3")
		_remove_group("SpinNail")
		_remove_group("EhosBigAttack")
		_remove_group("Ehos1t4")
		_remove_group("Ehos1t5")
		_remove_group("Hg_gem")
		_remove_group("Bullet")
		_remove_group("HoleTusk3Nail")
		_remove_group("BubbleBeyound")
		_remove_group("GoldNail")
		_remove_group("SecondDopEhosAct1")
		_remove_group("BubbleEyes")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("DefaultNail")
	
	elif General.stand_index == "TuskAct2" and is_dop_attack_three == false:
		var random_stand = ["TuskAct1", "TuskAct1", "TuskAct2"]
		var stand_random = random.randi_range(0, random_stand.size() - 1)
		General.vfx_stand_random = random_stand[stand_random]
		$AnimationPlayer.play(General.vfx_stand_random + "Idle")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
		if random_stand[stand_random] == "TuskAct1":
			_remove_group("Ehos1t1")
			_remove_group("Ehos1t2")
			_remove_group("Hg_gem")
			_remove_group("NailBDTusk3")
			_remove_group("HoleTusk3Nail")
			_remove_group("EhosBigAttack")
			_remove_group("Ehos1t3")
			_remove_group("SpinNail")
			_remove_group("Ehos1t4")
			_remove_group("Ehos1t5")
			_remove_group("BubbleEyes")
			_remove_group("Bullet")
			_remove_group("BubbleBeyound")
			_remove_group("KnifeTW")
			_remove_group("GoldNail")
			_remove_group("SecondDopEhosAct1")
			_remove_group("Tusk4MiniBd")
			_remove_group("SCRetroGun")
			$Area2D.add_to_group("DefaultNail")
		else:
			_remove_group("Ehos1t1")
			_remove_group("Ehos1t2")
			_remove_group("Ehos1t3")
			_remove_group("Ehos1t4")
			_remove_group("Ehos1t5")
			_remove_group("EhosBigAttack")
			_remove_group("KnifeTW")
			_remove_group("Hg_gem")
			_remove_group("BubbleBeyound")
			_remove_group("Bullet")
			_remove_group("DefaultNail")
			_remove_group("SecondDopEhosAct1")
			_remove_group("Tusk4MiniBd")
			_remove_group("SCRetroGun")
			$Area2D.add_to_group("GoldNail")

	elif General.stand_index == "TuskAct3" and is_dop_attack_three == false and is_dop_attack_second == false:
		var random_stand = ["TuskAct1", "TuskAct1", "TuskAct2", "TuskAct2"]
		var stand_random = random.randi_range(0, random_stand.size() - 1)
		General.vfx_stand_random = random_stand[stand_random]
		$AnimationPlayer.play(General.vfx_stand_random + "Idle")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
		if random_stand[stand_random] == "TuskAct1":
			_remove_group("Ehos1t1")
			_remove_group("Ehos1t2")
			_remove_group("HoleTusk3Nail")
			_remove_group("Ehos1t3")
			_remove_group("NailBDTusk3")
			_remove_group("SpinNail")
			_remove_group("Ehos1t4")
			_remove_group("Hg_gem")
			_remove_group("Ehos1t5")
			_remove_group("BubbleEyes")
			_remove_group("BubbleBeyound")
			_remove_group("Bullet")
			_remove_group("KnifeTW")
			_remove_group("GoldNail")
			_remove_group("EhosBigAttack")
			_remove_group("SecondDopEhosAct1")
			_remove_group("Tusk4MiniBd")
			_remove_group("NailBDTusk3")
			_remove_group("SCRetroGun")
			$Area2D.add_to_group("DefaultNail")
		else:
			_remove_group("Ehos1t1")
			_remove_group("Ehos1t2")
			_remove_group("Ehos1t3")
			_remove_group("Ehos1t4")
			_remove_group("Hg_gem")
			_remove_group("Ehos1t5")
			_remove_group("BubbleBeyound")
			_remove_group("KnifeTW")
			_remove_group("Bullet")
			_remove_group("DefaultNail")
			_remove_group("EhosBigAttack")
			_remove_group("SecondDopEhosAct1")
			_remove_group("Tusk4MiniBd")
			_remove_group("Tusk4MiniBd")
			_remove_group("SCRetroGun")
			_remove_group("NailBDTusk3")
			$Area2D.add_to_group("GoldNail")
	
	elif General.stand_index == "EhosAct1" and is_dop_attack_second == false and is_attack_strength == false:
		var random_stand = ["1", "2", "3", "4", "5"]
		var stand_random = random.randi_range(0, random_stand.size() - 1)
		$AnimationPlayer.play(General.stand_index + "Idle" + random_stand[stand_random])
		_remove_group("Bullet")
		_remove_group("Hg_gem")
		_remove_group("GoldNail")
		_remove_group("HoleTusk3Nail")
		_remove_group("NailBDTusk3")
		_remove_group("SpinNail")
		_remove_group("BubbleBeyound")
		_remove_group("KnifeTW")
		_remove_group("DefaultNail")
		_remove_group("BubbleEyes")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		for i in range(random_stand.size()):
			if i == stand_random:
				$Area2D.add_to_group("Ehos1t" + str(i + 1))
			else:
				_remove_group("Ehos1t" + str(i + 1))
	
	elif General.stand_index == "EhosAct1" and is_dop_attack_second and is_attack_strength == false:
		$AnimationPlayer.play(General.stand_index + "IdleSecondAttack")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("HoleTusk3Nail")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t4")
		_remove_group("Ehos1t5")
		_remove_group("BubbleBeyound")
		_remove_group("Bullet")
		_remove_group("SpinNail")
		_remove_group("GoldNail")
		_remove_group("Hg_gem")
		_remove_group("DefaultNail")
		_remove_group("BubbleEyes")
		_remove_group("KnifeTW")
		_remove_group("EhosBigAttack")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("SecondDopEhosAct1")
	
	elif General.stand_index == "EhosAct1" and is_dop_attack_second == false and is_attack_strength:
		$AnimationPlayer.play(General.stand_index + "IdleBigAttack")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("HoleTusk3Nail")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t5")
		_remove_group("Bullet")
		_remove_group("SpinNail")
		_remove_group("Hg_gem")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("BubbleBeyound")
		_remove_group("DefaultNail")
		_remove_group("KnifeTW")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("EhosBigAttack")
	
	elif General.stand_index in ["TheWorld", "MIH"]:
		$SOUND_EFFECT_START.play("KnifeTheWorld")
		$AnimationPlayer.play("TheWorld" + "Idle")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t5")
		_remove_group("HoleTusk3Nail")
		_remove_group("SpinNail")
		_remove_group("Bullet")
		_remove_group("Hg_gem")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("KnifeTW")
	
	elif General.stand_index == "Soft&Wet":
		$AnimationPlayer.play(General.stand_index + str(bubble_id) + "Idle")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("HoleTusk3Nail")
		_remove_group("Ehos1t5")
		_remove_group("Hg_gem")
		_remove_group("Bullet")
		_remove_group("NailBDTusk3")
		_remove_group("SpinNail")
		_remove_group("GoldNail")
		_remove_group("DefaultNail")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		_remove_group("KnifeTW")
		if bubble_id == 1:
			$SOUND_EFFECT_START.play("Bubble")
			_remove_group("BubbleBeyound")
			$Area2D.add_to_group("BubbleEyes")
			yield(get_tree().create_timer(3), "timeout")
			$SOUND_EFFECT_END.play("Bubble")
			var bubble_effects = bubble_effect.instance()
			get_parent().add_child(bubble_effects)
			bubble_effects.global_position = global_position
			speed = 0
			visible = false
			yield($SOUND_EFFECT_END, "animation_finished")
			queue_free()
		if bubble_id == 2:
			$SOUND_EFFECT_START.play("GoBeyound")
			_remove_group("BubbleEyes")
			$Area2D.add_to_group("BubbleBeyound")
			yield(get_tree().create_timer(120), "timeout")
			var bubble_effects = bubble_effect.instance()
			get_parent().add_child(bubble_effects)
			bubble_effects.global_position = global_position
			queue_free()
	
	elif General.stand_index == "TuskAct1" and is_dop_attack_three:
		$AnimationPlayer.play(General.stand_index + "IdleBigAttack")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("HoleTusk3Nail")
		_remove_group("Ehos1t3")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t4")
		_remove_group("Ehos1t5")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("Hg_gem")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("KnifeTW")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("SpinNail")
	
	elif General.stand_index == "TuskAct2" and is_dop_attack_three:
		$AnimationPlayer.play(General.stand_index + "IdleBigAttack")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
		_remove_group("Ehos1t1")
		_remove_group("HoleTusk3Nail")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("Ehos1t5")
		_remove_group("NailBDTusk3")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("Hg_gem")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("KnifeTW")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("SpinNail")
	
	elif General.stand_index == "TuskAct3" and is_dop_attack_three:
		$AnimationPlayer.play(General.stand_index + "IdleBigAttack")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
		_remove_group("Ehos1t1")
		_remove_group("HoleTusk3Nail")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("Ehos1t5")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("KnifeTW")
		_remove_group("Hg_gem")
		_remove_group("Tusk4MiniBd")
		_remove_group("SpinNail")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("NailBDTusk3")
	elif General.stand_index == "TuskAct4" and is_dop_attack_three:
		$AnimationPlayer.play(General.stand_index + "IdleBigAttack")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$AnimationPlayer.play(General.stand_index + "IdleBigAttack")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
		_remove_group("Ehos1t1")
		_remove_group("HoleTusk3Nail")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("Ehos1t5")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("KnifeTW")
		_remove_group("Hg_gem")
		_remove_group("Tusk4MiniBd")
		_remove_group("SpinNail")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("NailBDTusk3")
	elif General.stand_index == "TuskAct4" and is_dop_attack_three == false and is_dop_attack_second == false:
		$AnimationPlayer.play(General.stand_index + "Idle")
		if General.player_pos.x - General.enemy_position.x > 50 or General.player_pos.x - General.enemy_position.x < - 50:
			$SOUND_EFFECT_START.play("TuskNail")
			_remove_group("Ehos1t1")
			_remove_group("Ehos1t2")
			_remove_group("HoleTusk3Nail")
			_remove_group("Ehos1t3")
			_remove_group("NailBDTusk3")
			_remove_group("SpinNail")
			_remove_group("Ehos1t4")
			_remove_group("Ehos1t5")
			_remove_group("BubbleEyes")
			_remove_group("BubbleBeyound")
			_remove_group("Bullet")
			_remove_group("KnifeTW")
			_remove_group("DefaultNail")
			_remove_group("EhosBigAttack")
			_remove_group("SecondDopEhosAct1")
			_remove_group("SCRetroGun")
			_remove_group("Hg_gem")
			_remove_group("Tusk4MiniBd")
			$Area2D.add_to_group("GoldNail")
	elif General.stand_index == "ShadowTW":
		$SOUND_EFFECT_START.play("ShadowTWKnife")
		$AnimationPlayer.play(General.stand_index + "Idle")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t5")
		_remove_group("HoleTusk3Nail")
		_remove_group("SpinNail")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("Hg_gem")
		_remove_group("SCRetroGun")
		$Area2D.add_to_group("KnifeTW")
	elif General.stand_index == "TWOH":
		$SOUND_EFFECT_START.play("KnifeTheWorld")
		$AnimationPlayer.play(General.stand_index + "Idle")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t5")
		_remove_group("HoleTusk3Nail")
		_remove_group("SpinNail")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		_remove_group("Hg_gem")
		$Area2D.add_to_group("KnifeTW")
	elif General.stand_index == "SCRetro" or General.stand_index == "SCRetroW":
		$SOUND_EFFECT_START.play("KnifeTheWorld")
		$AnimationPlayer.play(General.stand_index + "Idle")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t5")
		_remove_group("HoleTusk3Nail")
		_remove_group("SpinNail")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("KnifeTW")
		_remove_group("Hg_gem")
		$Area2D.add_to_group("SCRetroGun")
	elif General.stand_index == "HeirophantGreen":
		$AnimationPlayer.play(General.stand_index + "Idle")
		_remove_group("Ehos1t1")
		_remove_group("Ehos1t2")
		_remove_group("Ehos1t3")
		_remove_group("Ehos1t4")
		_remove_group("NailBDTusk3")
		_remove_group("Ehos1t5")
		_remove_group("HoleTusk3Nail")
		_remove_group("SpinNail")
		_remove_group("Bullet")
		_remove_group("GoldNail")
		_remove_group("BubbleEyes")
		_remove_group("DefaultNail")
		_remove_group("BubbleBeyound")
		_remove_group("SecondDopEhosAct1")
		_remove_group("Tusk4MiniBd")
		_remove_group("SCRetroGun")
		_remove_group("KnifeTW")
		$Area2D.add_to_group("Hg_gem")
	if ("ToPos" in DopData):
		yield(get_tree(), "idle_frame")
		$AnimationPlayer.remove_animation("RESET")
		var AnimAnim = $AnimationPlayer.get_animation("MoveSmooth")
		AnimAnim.track_insert_key(0, 0.5, DopData["ToPos"] - global_position)
		AnimAnim.length = 0.5
		$AnimationPlayer.play("MoveSmooth")




func _physics_process(delta):


	if General.time_stop == false:
		if not ("ToPos" in DopData):
			move_and_slide(velocity * speed * delta * 30000 / General.mih_speed)
	if bubble:
		if bubble_id == 1:
			speed = 0.2
		else:
			speed = 0.8
func _on_VisibilityNotifier2D_screen_exited():
	while General.time_stop:
		yield(get_tree().create_timer(0.1), "timeout")
	if exit_timer == null or not is_instance_valid(exit_timer) or not exit_timer.is_inside_tree():
		return
	if not exit_timer.is_connected("timeout", self, "do_this"):
		exit_timer.connect("timeout", self, "do_this")
	exit_timer.wait_time = 3
	exit_timer.one_shot = true
	exit_timer.start()
func do_this():
	while General.time_stop:
		yield(get_tree().create_timer(0.1), "timeout")
	if bubble_id != 2:
		queue_free()
func _on_Area2D2_area_entered(area):
	if area.is_in_group("YSortGroup"):
		z_index = - 3
func _on_Area2D2_area_exited(area):
	if area.is_in_group("YSortGroup"):
		z_index = 3
func _on_Area2D_area_exited(_area):
	# Сигнал остаётся в BulletAttack.tscn для совместимости со старыми сценами.
	# Выход из Area2D не меняет состояние снаряда.
	pass


func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		while General.time_stop:
			yield(get_tree().create_timer(0.1), "timeout")
		$Area2D.queue_free()
		if type in [1, 3]:
			$SOUND_EFFECT_END.play("BigDamage")
		elif type == 4:
			yield(get_tree(), "idle_frame")


			



			speed = 0
			$SOUND_EFFECT_END.play("BigDamage")
			var da: Sprite = Sprite.new()
			da.texture = load("res://Textures/Others/Explosion.png")
			da.scale *= 0.7
			add_child(da)
			for i in 3:
				yield(get_tree().create_timer(0.07), "timeout")
				da.modulate.a = 0.5 * (2.0 - i)
			queue_free()
		else:
			if bubble == false:
				if $BulletTexture.frame in [7, 14]:
					
					$SOUND_EFFECT_END.play("BloodKnife")
					
					var da = preload("res://Scenes/Particles.tscn").instance()
					area.get_parent().add_child(da)
					da.Play("Blood")
					da.position.y -= 50
					da.z_index = 10
			
					
					
					
					




				elif $BulletTexture.frame == 11:
					$SOUND_EFFECT_END.play("BigDamage")
				elif $BulletTexture.frame == 0 or $BulletTexture.frame == 1 or $BulletTexture.frame == 10:
					$SOUND_EFFECT_START.stop(true)
					$SOUND_EFFECT_START / AudioStreamPlayer.playing = false
					$SOUND_EFFECT_END.play("TuskNail")
				elif $BulletTexture.frame != 13 and $BulletTexture.frame != 7 and $BulletTexture.frame != 12 and $BulletTexture.frame != 11 and $BulletTexture.frame != 0 or $BulletTexture.frame != 1 or $BulletTexture.frame != 10:
					$SOUND_EFFECT_END.play("DefaultDamage")
				speed = 0
				$BulletTexture.visible = false
				$Particles2D.visible = false

				yield($SOUND_EFFECT_END, "animation_finished")
				
				

				yield(get_tree().create_timer(0.8), "timeout")
				queue_free()
				
			else:
				if bubble_id == 1:
					$SOUND_EFFECT_END.play("Bubble")
					var bubble_effects = bubble_effect.instance()
					get_parent().add_child(bubble_effects)
					bubble_effects.global_position = global_position
					visible = false
					yield($SOUND_EFFECT_END, "animation_finished")
					queue_free()
				if bubble_id == 2:
					$Area2D.queue_free()


func Animation_Finished(anim_name):
	yield(get_tree().create_timer(0.05), "timeout")
	if anim_name == "MoveSmooth":
		queue_free()
