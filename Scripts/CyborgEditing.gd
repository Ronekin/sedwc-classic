# CyborgEditing.gd — экран сборки киборга.
#
# UI выбирает слоты рук/сердца/глаз/торса и показывает доступные детали.
# Характеристики и батарея пересчитываются в StatsService/PlayerStateService.

extends CanvasLayer

var Select = ["item", - 1]







func _ready():
	$Left / GridContainer / Item.visible = false
	$Right / Info.visible = false
	Update()



func _process(delta):
	
	$Center / Equips / Tors.visible = General.other_save["Cyborg"][1][5] != ""
	$Center / Equips / Hand1.visible = General.other_save["Cyborg"][1][1] != ""
	$Center / Equips / Hand2.visible = General.other_save["Cyborg"][1][2] != ""
	$Center / Equips / Heart.visible = General.other_save["Cyborg"][1][3] != ""
	if General.other_save["Cyborg"][1][6] == "":
		$Center / Equips / Heart.frame = 6
	else:
		if General.other_save["Cyborg"][1][3] == "6": $Center / Equips / Heart.frame = 4
		if General.other_save["Cyborg"][1][3] == "7": $Center / Equips / Heart.frame = 5
	$Center / Equips / Eye.visible = General.other_save["Cyborg"][1][4] != ""
	
	
	
	
	if $Right / Info / Icon.visible:
		$Right / Info / Light.visible = true
		match $Right / Info / Icon.frame:
			6, 10:
				$Right / Info / Light.modulate = Color("b800ff4c")
			7:
				$Right / Info / Light.modulate = Color("00b1ff")
			8:
				$Right / Info / Light.modulate = Color("ffffff")
			_:
				$Right / Info / Light.visible = false
			
	else:
		$Right / Info / Light.visible = false

func Update():
	for i in 3:
		var da: Object = get_node("Center/Moduls/Slot" + str(i))
		da.get_node("Icon").visible = General.other_save["Cyborg"][1][0][i] != ""
		if da.get_node("Icon").visible:
			
			var ItemIndex = General.other_save["Cyborg"][1][0][i]
			if ItemIndex.find("/") != - 1: ItemIndex = ItemIndex.split("/")[0]
			
			da.get_node("Icon").frame = int(ItemIndex)
	
	for i in $Left / GridContainer.get_children(): if i.visible: i.queue_free()
	
	for i in General.other_save["Cyborg"][0].size():
		var da = $Left / GridContainer / Item.duplicate()
		da.Numb = i
		if General.other_save["Cyborg"][0][i][0].find("/") != - 1:
			da.get_node("Icon").frame = int(General.other_save["Cyborg"][0][i][0].split("/")[0])
		else:
			da.get_node("Icon").frame = int(General.other_save["Cyborg"][0][i][0])
		da.get_node("CountText").text = str(General.other_save["Cyborg"][0][i][1])
		da.visible = true
		$Left / GridContainer.add_child(da)


func Hand1_Pressed():
	PieceSelect(1)


func Hand2_Pressed():
	PieceSelect(2)


func Heart_Pressed():
	PieceSelect(3)


func Eye_Pressed():
	PieceSelect(4)


func Tors_Pressed():
	PieceSelect(5)


func ItemSelect(Numb: int, Type: int):
	$Right / Info.visible = true
	General.SoundPlay("res://Music/HitUI.mp3")
	if Type == 0:
		Select = ["item", Numb]
		
		var ID: String = General.other_save["Cyborg"][0][Numb][0]
		var Info = GetItemInfo(ID)
		$Right / Info / ItemName.text = Info[0]
		$Right / Info / SlotName.text = ""
		
		
		var ItemIndex = ID
		if ID.find("/") != - 1: ItemIndex = ID.split("/")[0]
		
		$Right / Info / Icon.visible = true
		$Right / Info / Icon.frame = int(ItemIndex)

		var SlotText: String
		match Info[1]:
			0: SlotText = "модуль"
			1: SlotText = "рука"
			3: SlotText = "сердце"
			4: SlotText = "глаз"
			5: SlotText = "брюхо"
			6: SlotText = "реактор"
		
		if Info[1] == 1:
			$Right / Info / Button1.visible = true
			$Right / Info / Button1 / Text.text = "equip 1"

			$Right / Info / Button2.visible = true
			$Right / Info / Button2 / Text.text = "equip 2"
		else:
			$Right / Info / Button1.visible = true
			$Right / Info / Button1 / Text.text = "equip"

			$Right / Info / Button2.visible = false



		$Right / Info / ItemDescript.text = "слот: " + SlotText + "\n" + Info[2]
	elif Type == 1:
		Select = ["piece", 0, Numb]
		$Right / Info / SlotName.text = "модуль " + str(Numb + 1)
		var ID = General.other_save["Cyborg"][1][0][Numb]
		$Right / Info / Icon.visible = ID != ""
		
		General.other_save["Cyborg"][1][0][Numb]
		
		var ItemIndex = ID
		if ID.find("/") != - 1: ItemIndex = ID.split("/")[0]
		
		$Right / Info / Icon.visible = true
		$Right / Info / Icon.frame = int(ItemIndex)
		
		var ItemInfo = GetItemInfo(ID)
		
		$Right / Info / ItemName.text = ItemInfo[0]
		$Right / Info / ItemDescript.text = ItemInfo[2]
		
		$Right / Info / Button1.visible = true
		$Right / Info / Button1 / Text.text = "unequip"
		
		$Right / Info / Button2.visible = false



func PieceSelect(Piece: int):
	$Right / Info.visible = true
	
	General.SoundPlay("res://Music/HitUI.mp3")
	var SlotParam = [0, ""]
	match Piece:
		1: SlotParam = [1, "рука 1"]
		2: SlotParam = [2, "рука 2"]
		3: SlotParam = [3, "сердце"]
		4: SlotParam = [4, "глаз"]
		5: SlotParam = [5, "брюхо"]
		6: SlotParam = [6, "батарейка реактора"]
		0: SlotParam = [0, "модули"]
	$Right / Info / SlotName.text = SlotParam[1]
	
	Select = ["piece", SlotParam[0]]
	var ID = General.other_save["Cyborg"][1][SlotParam[0]]
	var ItemInfo = GetItemInfo(ID)
	$Right / Info / Icon.visible = ID != ""
	

		
	
	
	var ItemIndex = ID
	if ID.find("/") != - 1: ItemIndex = ID.split("/")[0]
		

	$Right / Info / Icon.frame = int(ItemIndex)

	
	
	
	
	$Right / Info / ItemName.text = ItemInfo[0]
	$Right / Info / ItemDescript.text = ItemInfo[2]
	if Piece == 6 and ID == "":
		$Right / Info / ItemName.text = "none"
	$Right / Info / Button1.visible = true
	$Right / Info / Button1 / Text.text = "unequip"
	
	if Piece == 3:
		$Right / Info / Button2.visible = true
		$Right / Info / Button2 / Text.text = "Battery"

		
	else:
	
		$Right / Info / Button2.visible = false

	if Piece == 6 and General.other_save["Cyborg"][1][6] != "":
		$Right / Info / ItemDescript.text = "осталось на " + str(stepify(float(General.other_save["Cyborg"][1][6].split("/")[1]), 1)) + " гдж"

func GetItemInfo(ID: String):
	var ItemInfo = ["имя", 0, "описание"]
	
	var ItemIndex = ID
	if ID.find("/") != - 1: ItemIndex = ID.split("/")[0]
	
	match ItemIndex:
		"0": ItemInfo = ["пулемёт", 5, "выстреливает очередью тратя патроны"]
		"1": ItemInfo = ["магазин", 0, "+75 патронов для пулемёта"]
		"2": ItemInfo = ["меха глаз", 4, ""]
		"3": ItemInfo = ["меха рука", 1, ""]
		"4": ItemInfo = ["акб", 0, "ёмкость 50 ГДж"]
		"5": ItemInfo = ["продвинутый акб", 0, "ёмкость 75 гдж"]
		"6": ItemInfo = ["ядерн. реактр", 3, "0.5 гдж/с"]
		"7": ItemInfo = ["дуговой реактор", 3, ""]
		"8": ItemInfo = ["продвинутый дуговой реактор", 3, ""]
		"9": ItemInfo = ["транзистор", 0, ""]
		"10": ItemInfo = ["урановая батарея", 6, ""]
		"11": ItemInfo = ["палладиевая батарея", 6, ""]
		"": ItemInfo = ["нет модификации", 146146, ""]
	return ItemInfo



func Modules_Pressed():
	pass


func Leave_pressed():
	General.persist_cyborg_battery_to_save()
	General.save_save()
	General.toGameGeneral()





func Button1_pressed():
	if Select[0] == "piece":
		
		var currentID = General.other_save["Cyborg"][1][Select[1]] if Select[1] != 0 else General.other_save["Cyborg"][1][0][Select[2]]
		var ItemInfo = GetItemInfo(currentID)
		
		if ItemInfo[0] != "нет модификации":
			if Select[1] != 0:
				General.AddItemToCyborgInv(str(General.other_save["Cyborg"][1][Select[1]]))
				General.other_save["Cyborg"][1][Select[1]] = ""
				PieceSelect(Select[1])
				if Select[1] == 3 and General.other_save["Cyborg"][1][6] != "":
					General.AddItemToCyborgInv(str(General.other_save["Cyborg"][1][6]))
					General.other_save["Cyborg"][1][6] = ""

			else:
				General.AddItemToCyborgInv(str(General.other_save["Cyborg"][1][0][Select[2]]))
				General.other_save["Cyborg"][1][0][Select[2]] = ""
				ItemSelect(Select[2], 1)
			Update()
			General.save_save()
	elif Select[0] == "item":
		var ID: String = General.other_save["Cyborg"][0][Select[1]][0]
		var Info = GetItemInfo(ID)
		if not (Info[1] in [1, - 1, 0, 6]):
			if General.other_save["Cyborg"][1][Info[1]] == "":
				General.other_save["Cyborg"][1][Info[1]] = ID
				General.other_save["Cyborg"][0][Select[1]][1] -= 1
				if General.other_save["Cyborg"][0][Select[1]][1] <= 0:
					General.other_save["Cyborg"][0].remove(Select[1])
		elif Info[1] == 1:
				var i = 0
				if General.other_save["Cyborg"][1][1 + i] == "":
					General.other_save["Cyborg"][1][1 + i] = ID
					General.other_save["Cyborg"][0][Select[1]][1] -= 1
					if General.other_save["Cyborg"][0][Select[1]][1] <= 0:
						General.other_save["Cyborg"][0].remove(Select[1])
		elif Info[1] == 6:
				if General.other_save["Cyborg"][1][6] == "" and ((ID.split("/")[0] == "10" and General.other_save["Cyborg"][1][3] == "6") or (ID.split("/")[0] == "11" and General.other_save["Cyborg"][1][3] == "7")):
					General.other_save["Cyborg"][1][6] = ID
					General.other_save["Cyborg"][0][Select[1]][1] -= 1
					if General.other_save["Cyborg"][0][Select[1]][1] <= 0:
						General.other_save["Cyborg"][0].remove(Select[1])

				
		elif Info[1] == 0:
			for i in 3:
				if General.other_save["Cyborg"][1][0][i] == "":
					General.other_save["Cyborg"][1][0][i] = ID
					General.other_save["Cyborg"][0][Select[1]][1] -= 1
					if General.other_save["Cyborg"][0][Select[1]][1] <= 0:
						General.other_save["Cyborg"][0].remove(Select[1])
					break
		$Right / Info.visible = false
		Update()
		General.save_save()

func Button2_pressed():
	if Select[0] == "item":
		var ID: String = General.other_save["Cyborg"][0][Select[1]][0]
		var Info = GetItemInfo(ID)

				
		if Info[1] == 1:
				var i = 1
				if General.other_save["Cyborg"][1][1 + i] == "":
					General.other_save["Cyborg"][1][1 + i] = ID
					General.other_save["Cyborg"][0][Select[1]][1] -= 1
					if General.other_save["Cyborg"][0][Select[1]][1] <= 0:
						General.other_save["Cyborg"][0].remove(Select[1])
	else:
		PieceSelect(6)
