# InventorySystem.gd — переключение страниц инвентаря и профиля.
#
# Это UI-контроллер: он не хранит предметы, а читает General.items_inventory.
# Публичные ID предметов — 0-based; Vector2.x в слотах — 1-based.

extends Node2D
var current_block: int


func _ready():
	PageChange(0)

func _on_Inventory_pressed(): PageChange(0)
func StandPressed(): PageChange(1)

func PageChange(Type: int):
	current_block = Type
	for i in [$InventoryPage, $ProfilePage]:
		i.visible = false
	match Type:
		0:
			$InventoryPage.visible = true
		1:
			
			$ProfilePage / SkillPoints.text = "skill points: " + str(General.points)
			$ProfilePage / Stats.text = ""
			for i in General.Stats:
				match i:
					"MoveSpeed": $ProfilePage / Stats.text += "move speed х" + str(General.Stats[i]) + "\n"
					"DH": $ProfilePage / Stats.text += "damage hands +" + str(General.Stats[i]) + "\n"
					"DP": $ProfilePage / Stats.text += "all damage x" + str(General.Stats[i]) + "\n"
					"Regen": $ProfilePage / Stats.text += "Regen hp x" + str(General.Stats[i]) + "\n"

			
			
			
			
			
			
			
			
			
			
			
			
			$ProfilePage.visible = true
			
			var text = ""
		
		
		
		
		




















			
			
			

			
			
		2:
			$TechnPage.visible = true
			var Info: Array = ["пусто", ""]
			match General.techic_number:
				1: Info = ["Spin", "тип: дальний\nскиллы: 2"]
				2: Info = ["Perfect Spin", "тип: дальний\nскиллы: 3"]
			$TechnPage / TechnicSelectIconSheet.visible = General.techic_number != 0
			$TechnPage / TechnicSelectIconSheet.frame = General.techic_number
			$TechnPage / Name.text = Info[0]
			$TechnPage / Descript.text = Info[1]
		3:
			$RacePage.visible = true
			
			var Info: Array = []
			
			match General.race_number:
				0: Info = [0, "human"]
				1: Info = [1, "vampire"]
				2: Info = [2, "pilarmen"]
				3: Info = [2, "evo pilarmen"]
				4: Info = [2, "perfect creature"]
			$RacePage / Name.text = Info[1]
			$RacePage / Descript.text = str("")
			$RacePage / RacesIcons.frame = Info[0]
		4:
			$ProfilePage.visible = true
			$ProfilePage / SkillPoints.text = "skill points: " + str(General.points)
			$ProfilePage / Stats.text = ""
			for i in General.Stats:
				match i:
					"MoveSpeed": $ProfilePage / Stats.text += "move speed х" + str(General.Stats[i]) + "\n"
					"DH": $ProfilePage / Stats.text += "damage hands +" + str(General.Stats[i]) + "\n"
					"DP": $ProfilePage / Stats.text += "all damage x" + str(General.Stats[i]) + "\n"
					"Regen": $ProfilePage / Stats.text += "Regen hp x" + str(General.Stats[i]) + "\n"
func MapPressed():
	General.player_pos = General.player_pos_save
	General.tutorial_id = 5
	Transition.change_scene("res://GeneralGameScenes/TutorialTema.tscn", "Black")
func _on_Next_pressed():
	pass
func ItemSelect(ItemID: int):
	$"AnimationPlayer".play("ItemInfoShow")
	$"AnimationPlayer".seek(0)
	General.SoundPlay("res://Music/HitUI.mp3")
	
	
		
	

	var item_data = General.content_db().get_item(int(ItemID) - 1)
	$ItemInfo / Name.text = str(item_data.get("item_name", ""))
