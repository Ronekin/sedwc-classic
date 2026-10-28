# EconomyService.gd — деньги, опыт, донат-бонусы и удача.
#
# Контракт: функции получают General и меняют только его поля. Множители
# доната одинаковы для money/exp/luck; новые бонусы добавляйте сюда, а не в UI.

extends Reference


func get_donate_level(general, bonus_type: String) -> int:
	if bonus_type == "money":
		if general.donate.find("money3") != - 1:
			return 4
		elif general.donate.find("money2") != - 1:
			return 3
		elif general.donate.find("money1") != - 1:
			return 2
		elif general.donate.find("money0") != - 1:
			return 1

	elif bonus_type == "exp":
		if general.donate.find("exp3") != - 1:
			return 4
		elif general.donate.find("exp2") != - 1:
			return 3
		elif general.donate.find("exp1") != - 1:
			return 2
		elif general.donate.find("exp0") != - 1:
			return 1
	elif bonus_type == "luck":
		if general.donate.find("luck3") != - 1:
			return 4
		elif general.donate.find("luck2") != - 1:
			return 3
		elif general.donate.find("luck1") != - 1:
			return 2
		elif general.donate.find("luck0") != - 1:
			return 1

	return 0


func money_change(general, amount):
	var level = get_donate_level(general, "money")
	var bonus = level * 0.1
	var multi = 1.0 + bonus

	if amount > 0:
		general.money += amount * multi
	else:
		general.money += amount


func exp_change(general, amount):
	var level = get_donate_level(general, "exp")
	var bonus = level * 0.1
	var multi = 1.0 + bonus

	if amount > 0:
		general.expirience_points += amount * multi
	else:
		general.expirience_points += amount
	return amount * multi


func chance_calculate(general, amount):
	var level = get_donate_level(general, "luck")
	var multi = level * 0.25
	if amount * multi == 0:
		return 0
	else:
		return amount * multi


func infinity_teleports(general):
	return general.donate.find("teleport") != - 1
