extends Control

export var money_indicators = {"money": true, "euro": true, "s_coins": true}

func _ready():
	$Label.visible = money_indicators["money"]
	$Label2.visible = money_indicators["euro"]
	$Label3.visible = money_indicators["s_coins"]
func _physics_process(delta):
	
	if General.money < 1000:
		$Label.text = "$:" + str(General.money)
	elif General.money >= 1000 and General.money < 1000000:
		$Label.text = "$:" + str(int(General.money / 1000)) + "K"
	elif General.money >= 1000000 and General.money < 1000000000:
		$Label.text = "$:" + str(int(General.money / 1000000)) + "M"
	elif General.money >= 1000000000:
		$Label.text = "$:" + str(int(General.money / 1000000000)) + "B"
	if General.euro < 1000:
		$Label2.text = "€:" + str(General.euro)
	elif General.euro >= 1000 and General.euro < 1000000:
		$Label2.text = "€:" + str(int(General.euro / 1000)) + "K"
	elif General.euro >= 1000000 and General.euro < 1000000000:
		$Label2.text = "€:" + str(int(General.euro / 1000000)) + "M"
	elif General.euro >= 1000000000:
		$Label2.text = "€:" + str(int(General.euro / 1000000000)) + "B"
	if General.s_coins < 10000:
		$Label3.text = "s:" + str(General.s_coins)
	elif General.s_coins >= 10000 and General.s_coins < 1000000:
		$Label3.text = "s:" + str(int(General.s_coins / 1000)) + "K"
	elif General.s_coins >= 1000000 and General.s_coins < 1000000000:
		$Label3.text = "s:" + str(int(General.s_coins / 1000000)) + "M"
	elif General.s_coins >= 1000000000:
		$Label3.text = "s:" + str(int(General.s_coins / 1000000000)) + "B"


