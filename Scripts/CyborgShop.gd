extends CanvasLayer

var Cost = [0, []]
var SelectID = - 1
var Shop_LVL = 1
var _craft_busy: = false







func _ready():
	$Right / BuyPanel / Description.text = ""
	$Right / BuyPanel / Name.text = ""
	$Right / BuyPanel / CraftButton.visible = false
	$Right / BuyPanel / GridContainer / ItemShop.visible = false
	if ("CybSh" in General.other_save) == false:
		General.other_save["CybSh"] = [1, []]
	ShopUpdate()

func _process(delta):
	$Left / MoneyText.text = str(General.money) + " $"


func FindInArray(ID: String, ArrayDa: Array) -> bool:
	for i in ArrayDa.size():
		if ArrayDa[i][0] == ID:
			return true
			
	return false

func ShopUpdate():
	
	var AllTechn = AllTechnCheck(true)
	
	if FindInArray("0", AllTechn) and FindInArray("1", AllTechn) and FindInArray("2", AllTechn):
		Shop_LVL = 2
		if FindInArray("4", AllTechn) and FindInArray("9", AllTechn):
			Shop_LVL = 3
	$Right / Text1.text = "technologia lvl: " + str(Shop_LVL)
	$Left / GridContainer / Item.visible = false
	for i in $Left / GridContainer.get_children(): if i.visible: i.queue_free()
	
	for i in [0, 1, 2]:
		var da = $Left / GridContainer / Item.duplicate()
		da.visible = true
		da.Numb = i
		da.get_node("Item").frame = i
		da.get_node("Text1").visible = false
		
		$Left / GridContainer.add_child(da)
	for i in [4, 9]:
			var da = $Left / GridContainer / Item.duplicate()
			da.visible = true
			da.Numb = i
			da.get_node("Item").frame = i

			if Shop_LVL >= 2: da.get_node("Text1").visible = false
			else:
				da.get_node("Text1").text = "lvl 2"

				da.get_node("Item").modulate = Color("000000")
				da.Numb = - 2
			$Left / GridContainer.add_child(da)
	for i in [5, 3]:
			var da = $Left / GridContainer / Item.duplicate()
			da.visible = true
			da.Numb = i
			da.get_node("Item").frame = i

			if Shop_LVL >= 3: da.get_node("Text1").visible = false
			else:
				da.get_node("Text1").text = "lvl 3"

				da.get_node("Item").modulate = Color("000000")
				da.Numb = - 2
			$Left / GridContainer.add_child(da)
	for i in [[6, 0], [10, 0], [7, 1], [11, 1], ]:
			var da = $Left / GridContainer / Item.duplicate()
			da.visible = true
			da.Numb = i[0]
			da.get_node("Item").frame = i[0]
			if i[1] in General.other_save["CybSh"][1]: da.get_node("Text1").visible = false
			else:
				da.Numb = - 1
				da.get_node("Text1").text = "?"
				da.get_node("Item").modulate = Color("000000")
			$Left / GridContainer.add_child(da)





func AllTechnCheck(EquipToo: bool) -> Array:
	var ReturnDa: Array
	for i in General.other_save["Cyborg"][0]: ReturnDa.append(i)
	if EquipToo:
		for i in General.other_save["Cyborg"][1]:
			if i is Array:
				for da in i:
					var Find = - 1
					for ga in ReturnDa.size():
						if ReturnDa[ga][0] == da:
							Find = ga
					if Find == - 1:
						ReturnDa.append([da, 1])
					else:
						ReturnDa[Find][1] += 1
			else:
				
					var Find = - 1
					for ga in ReturnDa.size():
						if ReturnDa[ga][0] == i:
							Find = ga
					if Find == - 1:
						ReturnDa.append([i, 1])
					else:
						ReturnDa[Find][1] += 1
				


	return ReturnDa

func Leave_Pressed():
	General.toGameGeneral()

func ItemSelect(Numb: int):
	$Right / BuyPanel.visible = true
	General.SoundPlay("res://Music/HitUI.mp3")
	var Info = ["название", "описание", [], 900]
	match Numb:
		- 1:
			Info = ["???", "неизвесная технология, нужен чертёж", [], 0]
		- 2:
			Info = ["???", "нужен более высокий уровень", [], 0]
		0:
			Info = ["Пулемёт", "слот : брюхо\nвыстреливает очередью тратя патроны", [[33, 20, "железо"], [34, 15, "свинец"]], 10000]
		1:
			Info = ["Магазин", "слот : снасти\n+75 патронов", [[33, 25, "железо"], [34, 20, "свинец"]], 9000]
		2:
			Info = ["мехо-глаз", "слот : глаз\nстреляет световым лучём, что потребляет 20 гдж/с", [[35, 10, "кремний"], [33, 15, "железо"], [36, 5, "фосфор"]], 12000]
		3:
			Info = ["мехо-рука", "слот : рука\nшанс 25% на поглащение 30% урона", [[35, 15, "кремний"], [33, 25, "железо"], [ - 9, 2, "транзистор"]], 12000]


		4:
			Info = ["АКБ", "слот : снасти\nёмкость : 50 ГДж", [[35, 20, "кремний"], [33, 30, "железо"], [37, 3, "электролит"]], 20000]
		5:
			Info = ["продвинутый АКБ", "слот : снасти\nёмкость : 75 ГДж", [[35, 20, "кремний"], [ - 4, 2, "АКБ"], [37, 3, "электролит"]], 20000]


		6:
			Info = ["мини ядерн. реактор", "слот : сердце\nвырабатывает 0.5 гдж/с", [[35, 30, "кремний"], [33, 35, "железо"], [34, 25, "свинец"]], 25000]


		7:
			Info = ["мини термоядерн. реактор", "слот : сердце\nвырабатывает 1.5 гдж/с\nможет выпускать энергитический луч", [[35, 35, "кремний"], [33, 45, "железо"], [34, 30, "свинец"]], 15000]


		10:
			Info = ["урановая батарейка", "слот : ядерн. реактор\nхватит на 750 гдж", [[35, 30, "кремний"], [41, 3, "уран 235"]], 15000]
		11:
			Info = ["палладиевая батарейка", "слот : термо ядерн. реактор\nхватит на 1200 гдж", [[45, 2, "паладий"]], 20000]

		9:
			Info = ["Транзистор", "слот : снасти\nурон атак потребляющих энергию увеличивается в 1.5 раза", [[35, 20, "кремний"], [33, 20, "железо"], [36, 10, "фосфор"]], 12000]
	

	$Right / BuyPanel / Name.text = Info[0]
	$Right / BuyPanel / Description.text = Info[1]

	$Right / BuyPanel / PriceUSD.text = str(Info[3]) + "$"
	$Right / BuyPanel / PriceUSD.visible = Numb > - 1
	Cost = [Info[3], Info[2]]
	SelectID = Numb
	
	for i in $Right / BuyPanel / GridContainer.get_children(): if i.visible: i.queue_free()
	
	for i in Info[2]:
		var jujutsu = $Right / BuyPanel / GridContainer / ItemShop.duplicate()
		jujutsu.visible = true
		if i[0] >= 0:
			jujutsu.get_node("Item").frame = i[0]
			jujutsu.get_node("Text").text = i[2] + "(" + str(General.ItemCount(i[0])) + "/" + str(i[1]) + ")"
		else:
			var Count = 0
			for b in AllTechnCheck(false):
				if b[0] == str( - i[0]):
					Count += b[1]
			
			jujutsu.get_node("Item").texture = $Left / GridContainer.get_child(0).get_node("Item").texture
			jujutsu.get_node("Item").hframes = $Left / GridContainer.get_child(0).get_node("Item").hframes
			jujutsu.get_node("Item").vframes = $Left / GridContainer.get_child(0).get_node("Item").vframes
			
			jujutsu.get_node("Item").frame = - i[0]
			jujutsu.get_node("Text").text = i[2] + "(" + str(Count) + "/" + str(i[1]) + ")"

		$Right / BuyPanel / GridContainer.add_child(jujutsu)
	
	var CanBuy = true
	
	if General.money >= Cost[0]:
		for i in Cost[1]:
			if i[0] >= 0:
				if General.ItemCount(i[0]) < i[1]:
					CanBuy = false
					break
			else:
				for hahaha in AllTechnCheck(false):
					if hahaha[0] == str( - i[0]):
						if hahaha[1] < i[1]:
							CanBuy = false
							break
	else:
		CanBuy = false
	$Right / BuyPanel / CraftButton.visible = CanBuy and Numb >= 0

func Craft_Pressed():
	var CanBuy = true
	
	if General.money >= Cost[0]: for i in Cost[1]:
			if i[0] >= 0:
				if General.ItemCount(i[0]) < i[1]:
					CanBuy = false
					break
			else:
				for hahaha in AllTechnCheck(false): if hahaha[0] == str( - i[0]):
						if hahaha[1] < i[1]:
							CanBuy = false
							break
	else: CanBuy = false
	
	if CanBuy:
		_craft_busy = true
		General.SoundPlay("res://Music/BuySound.mp3", {"Volume_db": 5})
		General.AddItemToCyborgInv(str(SelectID))
		General.money -= Cost[0]
		for i in Cost[1]:
			if i[0] >= 0: General.remove_item(i[0], i[1])
			else: for hahaha in General.other_save["Cyborg"][0].size():
					if General.other_save["Cyborg"][0][hahaha][0] == str( - i[0]):
						General.other_save["Cyborg"][0][hahaha][1] -= i[1]
						if General.other_save["Cyborg"][0][hahaha][1] <= 0: General.other_save["Cyborg"][0].remove(hahaha)
						break
		General.save_save()
		ItemSelect(SelectID)
		ShopUpdate()
		_craft_busy = false




