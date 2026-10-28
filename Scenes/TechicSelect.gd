extends CanvasLayer





var buy_click = 3

func _ready():
	ShowingUpdate()
	$Center / Buy.text = ""







func ShowingUpdate():
	var TechnicNameDa: String
	
	match General.techic_number:
		1: TechnicNameDa = "спин"
		2: TechnicNameDa = "идеальный спин"
	
	if General.techic_number == 0:
		$Center / TextInfo.text = "техники нет"
		$Center / TextInfo3.text = "Скина нет"
		$Center / TypeIcon.visible = false
		$Center / SkinIcon.visible = false
		$Center / Skins.visible = false
	else: $Center / TextInfo.text = "техника: " + TechnicNameDa
	
	$Center / TypeIcon.frame = General.techic_number - 1
	match General.choose_skins["spin"]:
		"default": $Center / SkinIcon.frame = 0
		"gold": $Center / SkinIcon.frame = 1
		"caramel": $Center / SkinIcon.frame = 2
	match General.choose_skins["spin"]:
		"default": $Center / TextInfo3.text = "Скин: обычный"
		"gold": $Center / TextInfo3.text = "Скин: золотой"
		"caramel": $Center / TextInfo3.text = "Скин: карамельный"
	$Center / Buy.text = ""

func _on_ButtonClassicSpin_pressed():
	General.choose_skins["spin"] = "default"
	General.SoundPlay("res://Music/HitUI.mp3")
	ShowingUpdate()


func _on_ButtonGoldSpin_pressed():
	if General.find_skin("gold") == 1:
		General.choose_skins["spin"] = "gold"
		General.SoundPlay("res://Music/HitUI.mp3")
		ShowingUpdate()
	else:
		if buy_click == 3:
			$Center / Buy.text = "стоимость скина - 10 s-койнов, нажмите 2 раза чтобы приобрести карамельный скин"
			buy_click = 2
		elif buy_click == 2:
			$Center / Buy.text = "нажав еще раз если у вас больше 10 s-койнов вы приобрете карамельный скин"
			buy_click = 1
		elif buy_click == 1:
			if General.s_coins >= 10:
				$Center / Buy.text = "Вы успешно приобрели золотой скин"
				General.all_skins.append("gold")
				General.s_coins -= 10
				General.save_save()
				buy_click = 3
			else:
				$Center / Buy.text = "Недостаточно s-койнов"

func _on_ButtonCandySpin_pressed():
	if General.find_skin("caramel") == 1:
		General.choose_skins["spin"] = "caramel"
		General.SoundPlay("res://Music/HitUI.mp3")
		ShowingUpdate()
	else:
		if buy_click == 3:
			$Center / Buy.text = "стоимость скина - 45 s-койнов, нажмите 2 раза чтобы приобрести карамельный скин"
			buy_click = 2
		elif buy_click == 2:
			$Center / Buy.text = "нажав еще раз если у вас больше 45 s-койнов вы приобрете карамельный скин"
			buy_click = 1
		elif buy_click == 1:
			if General.s_coins >= 45:
				$Center / Buy.text = "Вы успешно приобрели карамельный скин"
				General.all_skins.append("caramel")
				General.s_coins -= 45
				General.save_save()
				buy_click = 3
			else:
				$Center / Buy.text = "Недостаточно s-койнов"
func _on_LeaveButton_pressed():
		General.SoundPlay("res://Music/HitUI.mp3")
		General.save_save()
		General.toGameGeneral()
		


func _on_TechicShoip_pressed():
	pass
