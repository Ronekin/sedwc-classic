extends CanvasLayer
var random = RandomNumberGenerator.new()
var pex = 0
var auto_timer = Timer.new()
var armor = 0
var auto_save = Timer.new()

var type_egg = "Default"
onready var default = preload("res://Textures/Echoes Egg Act 0.png")
onready var onefoursix = preload("res://Textures/146EGG.png")

func _ready():
	update_stats()
	auto_save_timer()
	auto_click_timer()
func _process(delta):
	$GeneralMenuPanel / U_B / cost.text = str(General.egg_upgrade["power"] * 10 + 10) + " я.к"
	$GeneralMenuPanel / U_B2 / cost.text = str(General.egg_upgrade["auto_count"] * 100 + 100) + " я.к"
	$GeneralMenuPanel / U_B3 / cost.text = str(General.egg_upgrade["chance_double"] * 500 + 50) + " я.к"
	$GeneralMenuPanel / U_B4 / cost.text = str(General.egg_upgrade["auto_power"] * 200 + 200) + " я.к"
	$Text4.text = "яйцо уровень:" + str(General.egg_lvl)
	$Text3.text = "яйцо койны:" + str(General.egg_coin)
	if $HPBAR.value == 0:
		$Egg.frame = 0
	elif $HPBAR.value == armor:
		$Egg.frame = 1
	elif $HPBAR.value == armor * 2:
		$Egg.frame = 2
	elif $HPBAR.value == armor * 3:
		$Egg.frame = 3
	elif $HPBAR.value == armor * 4:
		$Egg.frame = 4
	if General.egg_lvl % 5 == 0:
		type_egg = "146"
	else:
		type_egg = "default"
	if type_egg == "default":
		$Egg.texture = default
	elif type_egg == "146":
		$Egg.texture = onefoursix
	if General.egg_lvl % 6 == 0:
		$Egg.self_modulate = Color.pink
	elif General.egg_lvl % 14 == 0:
		$Egg.self_modulate = Color.gold
	elif General.egg_lvl % 4 == 0:
		$Egg.self_modulate = Color.black
	elif General.egg_lvl % 146 == 0:
		$Egg.self_modulate = Color.goldenrod
	elif General.egg_lvl % 2 == 0:
		$Egg.self_modulate = Color.cyan
	elif General.egg_lvl % 3 == 0:
		$Egg.self_modulate = Color.red
	elif General.egg_lvl % 1 == 0:
		$Egg.self_modulate = Color.white
	$HPBAR.max_value = armor * 4
	$HPBAR.value = pex
	$HPBAR / HP.text = "оставшиеся хп:" + str(armor * 4 - pex)

func _on_exit_released():
	Transition.change_scene("res://GeneralGameScenes/GeneralMenu.tscn", "Black")
func update_stats():
	if General.egg_upgrade == null:
		General.egg_upgrade = {
	"power": 0, 
	"auto_count": 0, 
	"auto_power": 0, 
	"chance_double": 0
}
	if General.egg_coin == null:
		General.egg_coin = 0
	if General.egg_lvl == null:
		General.egg_lvl = 1
	$Text5.text = "Характеристики: " + "сила клика:" + str(1 + General.egg_upgrade["power"]) + " множитель кликов:" + str(1 + General.egg_upgrade["auto_power"]) + " колличество дополнительных кликов каждую секунду:" + str(General.egg_upgrade["auto_count"]) + " вероятность двойного урона:" + str(0.2 + General.egg_upgrade["chance_double"])
func update_armor():
	armor = General.egg_lvl

func _on_click_pressed():
	if pex < 4 * armor:
		pex += 1
	else:
		pex = 0
		General.egg_lvl += 1

		update_armor()
	random.randomize()
	var chance = random.randf()
	if chance >= 0.9 - General.egg_upgrade["chance_double"]:
		General.egg_coin += (1 + General.egg_upgrade["power"]) * 2 * (General.egg_upgrade["auto_power"] + 1)
	else:
		General.egg_coin += (1 + General.egg_upgrade["power"]) * (General.egg_upgrade["auto_power"] + 1)
	General.save_save()
func _on_U_B_pressed():
	if General.egg_coin >= 10 * General.egg_upgrade["power"] + 10:
		General.egg_coin -= 10 * General.egg_upgrade["power"] + 10
		General.egg_upgrade["power"] += 1
		General.save_save()
		update_stats()

func _on_U_B2_pressed():
	if General.egg_coin >= 100 * General.egg_upgrade["auto_count"] + 100:
		General.egg_coin -= 100 * General.egg_upgrade["auto_count"] + 100
		General.egg_upgrade["auto_count"] += 1
		General.save_save()
	update_stats()


func _on_U_B3_pressed():
	if General.egg_coin >= 500 * General.egg_upgrade["auto_count"] + 50 and (General.egg_upgrade["auto_count"] + 0.2) < 0.9:
		General.egg_coin -= 50 * General.egg_upgrade["auto_count"] + 50
		General.egg_upgrade["auto_count"] += 0.2
		General.save_save()
	update_stats()


func _on_U_B4_pressed():
	if General.egg_coin >= 200 * General.egg_upgrade["auto_power"] + 200:
		General.egg_coin -= 200 * General.egg_upgrade["auto_power"] + 200
		General.egg_upgrade["auto_power"] += 0.1
		General.save_save()
	update_stats()
	
func auto_click():
	General.egg_coin += General.egg_upgrade["auto_count"] * (General.egg_upgrade["auto_power"] + 1)
	General.save_save()
func auto_click_timer():
	auto_timer.connect("timeout", self, "auto_click")
	auto_timer.wait_time = 1
	auto_timer.one_shot = false
	add_child(auto_timer)
	auto_timer.start()
func auto_save_timer():
	auto_save.connect("timeout", self, "update_stats")
	auto_save.wait_time = 30
	auto_save.one_shot = false
	add_child(auto_save)
	auto_save.start()
