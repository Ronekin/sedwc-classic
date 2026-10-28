# Shop.gd — экран магазина.
#
# Показывает товары из Data/ShopItems.gd и вызывает покупку через
# General/InventoryService. Цены и скидки не дублируйте в UI.

extends Node2D

var current_id = 0
var count = 1

func _ready():
	$All / Control / Sprite.frame = General.items_shop[current_id]["ID"]
	$All / Text / Cost.text = str(General.items_shop[current_id]["COST"]) + "$"
	$All / Text / Cost2.text = str(General.items_shop[current_id]["COST"] / 2) + "$"
	$All / Text / Name2.text = General.items_shop[current_id]["DISCRIPTION"]
	$All / Text / Name.text = General.items_shop[current_id]["NAME"]
	$All / Text / Name4.text = "у вас есть: " + str(General.ItemCount(General.items_shop[current_id]["ID"]))
	$All / Center / Name5.text = "денег в наличии: " + str(General.money) + "$"

func _process(delta):
	if $All / Back / CodeBox / CodeText.text == "":
		$All / Back / CodeBox / CodeText.text = "1"
		count = 1

func next_frame_start():
	_ready()

func _on_TouchScreenButton_pressed():
	if current_id > 0 and $AnimationPlayer.current_animation == "":
		current_id -= 1
		$AnimationPlayer.play("ChangeItem")

func _on_TouchScreenButton2_pressed():
	if current_id < (General.items_shop.size() - 1) and $AnimationPlayer.current_animation == "":
		current_id += 1
		$AnimationPlayer.play("ChangeItem")

func _on_TouchScreenButton22_pressed():
	if General.money >= (General.items_shop[current_id]["COST"] * count) and count > 0:
		General.AchievementGive(29)
		General.money -= General.items_shop[current_id]["COST"] * count
		General.add_item(General.items_shop[current_id]["ID"], count)
		$All / Control2 / Name4.text = "Куплено!"
		$All / Control2 / AnimationPlayer.stop(true)
		$All / Control2 / AnimationPlayer.play("Idle")
		$All / Back / Buy.play()
		
		if General.items_shop[current_id]["ID"] == 5:
			General.AchievementGive(30)
		
		General.save_save()
		_ready()
	else:
		$All / Control2 / Name4.text = "Недостаточно денег"
		$All / Control2 / AnimationPlayer.stop(true)
		$All / Control2 / AnimationPlayer.play("Idle")

func _on_TouchScreenButton3_pressed():
	var item_id = General.items_shop[current_id]["ID"]
	var item_count = General.ItemCount(item_id)
	
	if item_count >= count and count > 0:
		General.money += (General.items_shop[current_id]["COST"] / 2) * count
		General.remove_item(item_id, count)
		$All / Control2 / Name4.text = "Продано!"
		$All / Control2 / AnimationPlayer.stop(true)
		$All / Control2 / AnimationPlayer.play("Idle")
		General.save_save()
		$All / Back / Sell.play()
		_ready()
	else:
		$All / Control2 / Name4.text = "У вас нет этого товара"
		$All / Control2 / AnimationPlayer.stop(true)
		$All / Control2 / AnimationPlayer.play("Idle")

func _on_TouchScreenButton31_pressed():
	General.toGameGeneral()

func _on_CodeText_text_changed(new_text: String):
	var filtered = ""
	var has_minus = false
	
	for i in range(new_text.length()):
		var c = new_text[i]
		if c >= "0" and c <= "9":
			filtered += c
		elif c == "-" and i == 0 and not has_minus:
			filtered += c
			has_minus = true
	
	if filtered == "" or filtered == "-":
		count = 0
	else:
		count = int(filtered)
	
	$All / Back / CodeBox / CodeText.text = filtered
	$All / Back / CodeBox / CodeText.caret_position = filtered.length()
