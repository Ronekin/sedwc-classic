extends Control

export var id = 0
onready var StandHead = $Sprite

func _physics_process(delta):
	if General.stand_slots[id] == 0:
		StandHead.visible = false
		$StandSlotIcon / Sprite2.visible = true
	else:
		StandHead.visible = true
		$StandSlotIcon / Sprite2.visible = false
	match id:
		5:
			if General.donate.find("slot0") == - 1:
				$"ReStandButton".visible = false
				$Node2D / StandText.text = "приобрите первый слот"
		6:
			if General.donate.find("slot1") == - 1:
				$"ReStandButton".visible = false
				$Node2D / StandText.text = "приобрите второй слот"
		7:
			if General.donate.find("slot2") == - 1:
				$"ReStandButton".visible = false
				$Node2D / StandText.text = "приобрите третий слот"
		8:
			if General.donate.find("slot3") == - 1:
				$"ReStandButton".visible = false
				$Node2D / StandText.text = "приобрите четвертый cлот"
	$Node2D.visible = not $ReStandButton.visible
	if $Node2D.visible:
		$Disc.modulate = Color("000000")
		$StandNamePanel / StandText.text = ""
		


	match General.stand_slots[id]:
		0: $StandNamePanel / StandText.text = "Empty"
		1: $StandNamePanel / StandText.text = "The World"
		2: $StandNamePanel / StandText.text = "Star Platinum"
		3: $StandNamePanel / StandText.text = "Gold Experience"
		4: $StandNamePanel / StandText.text = "Tusk Act 1"
		5: $StandNamePanel / StandText.text = "Tusk Act 2"
		6: $StandNamePanel / StandText.text = "Echoes Act 1"
		7: $StandNamePanel / StandText.text = "Echoes Act 0"
		8: $StandNamePanel / StandText.text = "King Crimson"
		9: $StandNamePanel / StandText.text = "Tusk Act 3"
		10: $StandNamePanel / StandText.text = "Soft & Wet"
		11: $StandNamePanel / StandText.text = "Tusk Act 4"
		12: $StandNamePanel / StandText.text = "secret"
		13: $StandNamePanel / StandText.text = "KK:Dopio"
		14: $StandNamePanel / StandText.text = "Shadow The World"
		15: $StandNamePanel / StandText.text = "TW:Greatest High"
		16: $StandNamePanel / StandText.text = "TW:Over Heaven"
		17: $StandNamePanel / StandText.text = "GE:REQUIM"
		18: $StandNamePanel / StandText.text = "Silver Chariot"
		20: $StandNamePanel / StandText.text = "White Snake"
		22: $StandNamePanel / StandText.text = "C-Moon"
		23: $StandNamePanel / StandText.text = "Made in heaven"
		24: $StandNamePanel / StandText.text = "GE:REQUIM"
		25: $StandNamePanel / StandText.text = "D4C"
		26: $StandNamePanel / StandText.text = "Wonder of U"
		27: $StandNamePanel / StandText.text = "Hierophant Green"
	match General.stand_slots[id]:
		0: StandHead.visible = false
		1: StandHead.frame = 0
		2: StandHead.frame = 9
		3: StandHead.frame = 1
		4: StandHead.frame = 2
		5: StandHead.frame = 3
		6: StandHead.frame = 4
		7: StandHead.frame = 5
		8: StandHead.frame = 6
		9: StandHead.frame = 7
		10: StandHead.frame = 8
		11: StandHead.frame = 10
		13: StandHead.frame = 18
		14: StandHead.frame = 12
		16: StandHead.frame = 11
		17: StandHead.frame = 13
		18: StandHead.frame = 14
		20: StandHead.frame = 15
		22: StandHead.frame = 16
		23: StandHead.frame = 17
		24: StandHead.frame = 13
		25: StandHead.frame = 19
		26: StandHead.frame = 20
		27: StandHead.frame = 21
func _on_AddButton_pressed():
	General.add_stand_to_slot(id)
func _on_RemoveButton_pressed():
	General.return_stand_from_slot(id)
func _on_ReStandButton_pressed():
	General.restand_to_slot(id)
