extends TouchScreenButton

export var attack_id = 0
var pressed_activate = false
var cooldown_reduction = 1
var use_spin_gyro = 1
var use_spin_inf = 1
var use_default = 1
var spin_reduction = 0
signal spin_default_go
signal spin_infinity_go
signal spin_inf_defense_go
signal spin_gyro_go
signal laser_cyborg_go
signal defense_spin_go

var CoolDown: bool = false
var CoolDownId: int = 0
var Disabled: bool = false

var player
var visible_skill_1 = false
func _physics_process(delta):
	spin_reduction = General.Addition["spin"] * 0.5
	if General.player_block_all:
		$Node2D / AnimationPlayer.playback_speed = 0
	else:
		if General.techic_number == 1 or General.techic_number == 2:
			$Node2D / AnimationPlayer.playback_speed = 1 * cooldown_reduction + spin_reduction
		else:
			$Node2D / AnimationPlayer.playback_speed = 1 * cooldown_reduction
	
	if $Sprite.frame == 12:
		var have = false
		if pressed_activate:
			General.Addition["spin"] += delta * 20
			if General.Addition["spin"] > 110:
				General.Addition["spin"] = 110
			player.Cast = 1
		else:
			player.Cast = 0
			
			if General.Addition["spin"] > 0:
				General.Addition["spin"] -= delta * 5
	
	var FrameDa = - 1
	if attack_id > 0:
		match General.techic_number:
			1: match attack_id:
				1: FrameDa = 12
				2: FrameDa = 0
			2: match attack_id:
				1: FrameDa = 12
				2: FrameDa = 0
				3: FrameDa = 2
			3: match attack_id:
				1: FrameDa = 10
			6, 7: match attack_id:
				1: FrameDa = 11
	else:
		match General.race_number:
			1: match - attack_id:
				1:
					if "LV" in General.Stats:
						FrameDa = 11
				2:
					if "VB" in General.Stats and General.Stats["VB"] > 1:
						FrameDa = 13
						if pressed_activate:
							General.Addition["RegenVamp"] = true
							if not ("VampReg" in General.SoundsDa):
								General.SoundPlay("res://Music/BloodRegen.mp3", {"Loop": true, "ID": "VampReg"})
						else:
							if "VampReg" in General.SoundsDa:
								General.SoundsDa["VampReg"].queue_free()
								General.SoundsDa.erase("VampReg")
							General.Addition.erase("RegenVamp")
			5: match - attack_id:
				1:
					if General.other_save["Cyborg"][1][5] != "":
						FrameDa = 15
						if pressed_activate:
							General.Addition["C_Gatling"] = true
						else:
							General.Addition.erase("C_Gatling")
				2:
					if General.other_save["Cyborg"][1][4] != "":
						FrameDa = 11
						if pressed_activate:
							General.Addition["C_Laser"] = true
							if not ("C_Laser" in General.SoundsDa):
								General.SoundPlay("res://Music/Laser.mp3", {"Loop": true, "Volume_db": 7, "ID": "C_Laser"})
						else:
							if "C_Laser" in General.SoundsDa:
								General.SoundsDa["C_Laser"].queue_free()
								General.SoundsDa.erase("C_Laser")
							General.Addition.erase("C_Laser")
				3:
					if General.other_save["Cyborg"][1][3] == "7":
						FrameDa = 14
						if not ("C_Charge" in General.Addition):
							return
						if General.Addition["C_Charge"] > 25:
							Disabled = false
						else:
							Disabled = true
						
						if Disabled:
							$Sprite.modulate = Color("828282")
						elif not CoolDown:
							$Sprite.modulate = Color("ffffff")
	
	if FrameDa == - 1:
		visible = false
	else:
		visible = true
		$Sprite.frame = FrameDa
		if attack_id == 1:
			if General.hands_opens["agility"] == false and (General.techic_number == 0 or General.techic_number == 3):
				visible = false
		if attack_id == 3 and (General.techic_number == 1 or General.techic_number == 2):
			if visible_skill_1 == true:
				visible = true
			else:
				visible = false
	if attack_id < 0:
		get_parent().visible = visible

func _on_DopButton_pressed():
	pressed_activate = true
	if CoolDown or Disabled:
		return
	
	if attack_id > 0:
		if attack_id == 2 and General.techic_number in [1, 2]:
			if $Node2D / AnimationPlayer.current_animation != "KD_Ball_SPIN" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
				
				var have = false
				for i in General.Addition["balls"].size():
					if General.Addition["balls"][i] == true:
						General.Addition["balls"][i] = false
						have = true
						break
				if have == false:
					return
				player.Attack("BallShot")
				
				use_default += 1
				if use_default > 1:
					use_default = 0
					CoolDown(15)
				else:
					CoolDown(2)
					
		if attack_id == 3 and General.techic_number in [2]:
			if $Node2D / AnimationPlayer.current_animation != "KD_Ball_SPIN" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
				
				if General.Addition["balls"][0] == true and General.Addition["balls"][1] == true:
					General.Addition["balls"][0] = false
					General.Addition["balls"][1] = false
					player.Attack("BallShotInfinity")
				
					use_default += 2
					if use_default > 1:
						use_default = 0
						CoolDown(25)
				else:
					General.message_spawn("Center", "Требуется два активных шара!")
					CoolDown(2)
		if attack_id == 1 and General.techic_number == 6:
			if $Node2D / AnimationPlayer.current_animation != "KD_" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
				if General.battery_charge >= 10:
					connect("laser_cyborg_go", player, "laser_cyborg_go")
					emit_signal("laser_cyborg_go")
					disconnect("laser_cyborg_go", player, "laser_cyborg_go")
				else:
					$Node2D / AnimationPlayer.play("KD_Laser")
					
		if attack_id == 1 and (General.techic_number == 3 or (General.techic_number == 0 and General.hands_opens["agility"] == true)):
			if $Node2D / AnimationPlayer.current_animation != "KD_Fear_Combat" and General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
				General.global_debuffs["hand_fear"] = true
				$Node2D / AnimationPlayer.play("KD_Fear_Combat")
	else:
		match General.race_number:
			1: match - attack_id:
				1:
					if General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
						player.Attack("LV")
						CoolDown(20)
			5: match - attack_id:
				1:
					if General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
						General.SoundPlay("res://Music/GunTake.mp3")
						player.Attack("C_Gatling")
				2:
					if General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
						player.Attack("C_Laser")
				3:
					if General.attacked == false and General.blocked == false and General.player_attack_activate == false and General.dashed == false and General.player_block_all == false and General.barrage_activate == false and General.dostup_combo and General.is_bubble_beyound_activate == false:
						player.Attack("R_L")
						General.Addition["C_Charge"] -= 25.0
						CoolDown(10)

func _on_DopButton_released():
	pressed_activate = false
	if General.race_number == 5 and attack_id == - 2:
		CoolDown(10)

func _ready():
	if General.techic_number == 2 and visible_skill_1 == false:
		for i in General.complete_quests.size():
					if General.complete_quests[i] == 3.8:
						visible_skill_1 = true
					else:
						visible_skill_1 = false
	if get_tree().current_scene.name != "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/YSorting/GGPlayer")
		if player == null:
			player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	elif get_tree().current_scene.name == "MorioMap":
		player = get_node("/root/" + get_tree().current_scene.name + "/SortingY/GGPlayer")
	
	if General.current_support["Name"] == "Gyro":
		cooldown_reduction = 2.5
		use_spin_gyro = 2
		use_spin_inf = 2
		use_default = 2

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
