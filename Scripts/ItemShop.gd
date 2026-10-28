# ItemShop.gd — карточка товара в магазине.
#
# Показывает предмет, цену и уровень скидки. Покупка идёт через General/
# InventoryService; не дублируйте здесь формулы денег.

extends Control

onready var icon = $Icons
var cost = 0
export var type = ""
var level = 0
var count = 0
var bonus = ""

func _ready():
	create_item()
	update_text()

func update_costs():
	if type == "money":
		cost = 75 + level * 75
	elif type == "exp":
		cost = 100 + level * 100
	elif type == "luck":
		cost = 200 + level * 200
	elif type == "slot":
		cost = 150 + level * 150
	elif type == "teleport":
		cost = 500

func create_item():
	
	update_level_from_donate()
	
	if type == "money":
		bonus = "+10% к деньгам"
		match level:
			1: icon.frame = 3
			2: icon.frame = 2
			3: icon.frame = 1
			4: icon.frame = 0
			_: icon.frame = 3
			
	elif type == "exp":
		bonus = "+10% к опыту"
		match level:
			1: icon.frame = 7
			2: icon.frame = 6
			3: icon.frame = 5
			4: icon.frame = 4
			_: icon.frame = 7
			
	elif type == "luck":
		bonus = "+25% к шансу выпадения предмета после боя"
		match level:
			1: icon.frame = 11
			2: icon.frame = 10
			3: icon.frame = 9
			4: icon.frame = 8
			_: icon.frame = 11
			
	elif type == "slot":
		bonus = "+1 слот стенда"
		match level:
			1: icon.frame = 15
			2: icon.frame = 14
			3: icon.frame = 13
			4: icon.frame = 12
			_: icon.frame = 15
			
	elif type == "teleport":
		bonus = "Бесплатные телепорты"
		if General.donate.find("teleport") != - 1:
			level = 1
		else:
			level = 0
		icon.frame = 19

func update_level_from_donate():
	"Обновляет уровень из массива donate (сохраняя вашу логику find)"
	if type == "money":
		if General.donate.find("money3") != - 1:
			level = 4
		elif General.donate.find("money2") != - 1:
			level = 3
		elif General.donate.find("money1") != - 1:
			level = 2
		elif General.donate.find("money0") != - 1:
			level = 1
		else:
			level = 0
			
	elif type == "exp":
		if General.donate.find("exp3") != - 1:
			level = 4
		elif General.donate.find("exp2") != - 1:
			level = 3
		elif General.donate.find("exp1") != - 1:
			level = 2
		elif General.donate.find("exp0") != - 1:
			level = 1
		else:
			level = 0
			
	elif type == "luck":
		if General.donate.find("luck3") != - 1:
			level = 4
		elif General.donate.find("luck2") != - 1:
			level = 3
		elif General.donate.find("luck1") != - 1:
			level = 2
		elif General.donate.find("luck0") != - 1:
			level = 1
		else:
			level = 0
			
	elif type == "slot":
		if General.donate.find("slot3") != - 1:
			level = 4
		elif General.donate.find("slot2") != - 1:
			level = 3
		elif General.donate.find("slot1") != - 1:
			level = 2
		elif General.donate.find("slot0") != - 1:
			level = 1
		else:
			level = 0
	
	elif type == "teleport":
		
		if General.donate.find("teleport") != - 1:
			level = 1
		else:
			level = 0

func _on_Info_pressed():
	update_costs()
	
	
	if count < 2:
		count += 1
	elif count >= 2:
		
		
		var can_buy = false
		
		if type == "teleport":
			
			if General.s_coins >= cost and level == 0:
				can_buy = true
		else:
			
			if General.s_coins >= cost and level < 4:
				can_buy = true
		
		if can_buy:
			General.s_coins -= cost
			
			
			if type == "teleport":
				
				if General.donate.find("teleport") == - 1:
					General.donate.append("teleport")
					level = 1
			else:
				
				General.donate.append(type + str(level))
			
			
			update_level_from_donate()
			create_item()
			
			General.save_save()
		
		count = 0
	
	update_text()

func update_text():
	update_costs()
	
	
	$Description.text = "ваш уровень: " + str(level) + " "
	$Description.text += "бонус за 1 уровень: " + str(bonus) + " "
	
	
	if type == "teleport":
		if level < 1:
			$Description.text += "стоимость покупки: " + str(cost) + " "
		else:
			$Description.text += "УЖЕ КУПЛЕНО! (максимум) "
	elif level < 4:
		$Description.text += "стоимость улучшения: " + str(cost) + " "
	else:
		$Description.text += "ДОСТИГНУТ МАКСИМУМ! "
