# StatsService.gd — пересчёт производных характеристик игрока.
#
# Контракт: update() получает General и меняет Stats, hp_max и Addition.
# Вызывайте после изменения расы, техники, талантов или баффов.

extends Reference


# Stats — итоговые множители, Addition — временные бонусы/флаги (Rage, Blood,
# Cyborg...). Не храните временное состояние в Stats.
func update(general):
	var bth: float = 0
	var HpByRace: float = 100
	general.Stats["MoveSpeed"] = 1.0
	general.Stats["DH"] = 0.0
	general.Stats["DP"] = 1.0
	general.Stats["Regen"] = 1.0
	general.Stats["D"] = 0.0
	
	if general.race_number == 5:
		general.Stats["C_Volume"] = 0.0
		if ("C_Charge" in general.Addition) == false: general.Addition["C_Charge"] = 0.0
		if ("C_bullets" in general.Addition) == false: general.Addition["C_bullets"] = 0
		if ("C_Battery" in general.Addition) == false: general.Addition["C_Battery"] = 0.0
		general.Stats["C_ChargeSpeed"] = 0.0
		general.Stats["C_max_bullets"] = 0
		general.Stats["C_ED"] = 1.0
		general.Stats["C_Chance"] = 0.0
		
		

		

	
	
		
		for i in general.other_save["Cyborg"][1][0]:
			if i == "4":
				general.Stats["C_Volume"] += 50
				
			elif i == "5":
				general.Stats["C_Volume"] += 75
			elif i == "9":
				general.Stats["C_ED"] *= 1.5
			elif i == "1":
				general.Stats["C_max_bullets"] += 75
		for i in general.other_save["Cyborg"][1].size() - 1:
			match i + 1:
				1, 2:
					general.Stats["C_Chance"] += 0.25
				3:
					if general.other_save["Cyborg"][1][i + 1] != "":
						if general.other_save["Cyborg"][1][6] != "" and (float(general.other_save["Cyborg"][1][6].split("/")[1]) >= 0):
							if general.other_save["Cyborg"][1][3] == "6":
								general.Stats["C_ChargeSpeed"] += 0.5
							elif general.other_save["Cyborg"][1][3] == "7":
								general.Stats["C_ChargeSpeed"] += 1.5

				
				
				
				
	
	
	bth += float(general.content_db().get_technic(general.techic_number).get("hp_bonus", 0.0))
	HpByRace = float(general.content_db().get_race(general.race_number).get("hp", 100.0))
	
	
	var AllBuffs = {}
	for i in general.talents["race"]:
		var Buffs = general.GetTalentInfo("race", i)[3]
		for badakaDA in Buffs:
			if badakaDA in AllBuffs:
				AllBuffs[badakaDA] += Buffs[badakaDA]
			else:
				AllBuffs[badakaDA] = Buffs[badakaDA]
	if "HP" in AllBuffs: bth += AllBuffs["HP"]
	if "MoveSpeed" in AllBuffs: general.Stats["MoveSpeed"] += (AllBuffs["MoveSpeed"] / 100)
	if "DamageHands" in AllBuffs: general.Stats["DH"] += AllBuffs["DamageHands"]
	if "DamageProcent" in AllBuffs: general.Stats["DP"] += AllBuffs["DamageProcent"] / 100
	if "Regen" in AllBuffs: general.Stats["Regen"] += AllBuffs["Regen"] / 100
	if "Rage" in AllBuffs:
		general.Stats["Rage"] = 0
		if not ("Rage" in general.Addition): general.Addition["Rage"] = 0.0
	else: general.Stats.erase("Rage")
	
	if "Rage+" in AllBuffs: general.Stats["Rage"] = 1
	if "LV" in AllBuffs: general.Stats["LV"] = 0
	else: general.Stats.erase("LVффффф")
	if "VB" in AllBuffs:
		general.Stats["VB"] = 0
		if not ("Blood" in general.Addition): general.Addition["Blood"] = 0.0
	else: general.Stats.erase("VB")
	if "VB+" in AllBuffs: general.Stats["VB"] = 1
	if "VB++" in AllBuffs: general.Stats["VB"] = 2
	
	if "BERSERK" in AllBuffs: general.Stats["BERSERK"] = true
	else: general.Stats.erase("BERSERK")


	if ("BERSERK" in general.Addition) and general.Addition["BERSERK"] == 1:
		general.Stats["DP"] *= 2.5
		general.Stats["D"] += 0.5
		general.Stats["MoveSpeed"] *= 1.5
	if ("RageMode" in general.Addition):
		general.Stats["DP"] *= 2.0
		general.Stats["MoveSpeed"] *= 1.4
	

	
	general.hp_max = HpByRace + general.bonus_player["health"] + bth
