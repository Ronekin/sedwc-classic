extends Control
var Temp: float = 0.0
var Pressure: float = 0.0
var ScrollBarIsPressed: bool
var Progress: float = 0.0
var MiniGameType: int = 0






func _ready():
	pass

func MiniGamaSet(MiniGame: int):
	MiniGameType = MiniGame
	$Control / hello4.text = "<\nкислотность"
	$Control / hello8.text = "<2\npH"
	$Control / hello9.text = "<1\npH"



	$Control / hello5.text = "< 900°C"
	$Control / hello6.text = "< 800°C"



	$Control / Pressure.tint_progress = Color("00ffab")
	$Control / StateText.text = "хим. очистка"

func _process(delta):
	
	$Control / Temp.value = Temp
	$Control / Pressure.value = Pressure
	$Control / Progress.value = Progress
	
	if Temp < 0: Temp = 0.0
	if Pressure < 0: Pressure = 0.0
	if Pressure > 100: Pressure = 100.0
	
	
	if MiniGameType == 0:
		if Temp > 55 and Pressure > 45:
			Progress += delta / 0.4
	elif MiniGameType == 1:
		if Pressure > 45 and Pressure < 75:
			Progress += delta / 0.3
	elif MiniGameType == 2:
		if Temp > 55:
			Progress += delta / 0.3
	
	
	Temp -= delta * 10
	if $Control / TempUp.is_pressed():
		if MiniGameType == 2:
			Temp += delta * 70
		else:
			Temp += delta * 30
	if not ScrollBarIsPressed:
		$Control / VScrollBar.value -= delta * 120.0
	if MiniGameType == 2:
		Pressure += delta * 20
	else:
		Pressure += delta * 12
		
	if $Control / VScrollBar.value > 95:
		Pressure -= delta * 30
	
	if Progress >= 100:
		if MiniGameType == 0:
			General.remove_item(43, 5, 1)
			General.SoundPlay("res://Music/CentrifugesEnd.mp3")
			General.add_item(44, 1)
			queue_free()
		elif MiniGameType == 1:
			MiniGameType = 2
			General.SoundPlay("res://Music/CentrifugesEnd.mp3")
			$Control / StateText.text = "выпаривание"
			Progress = 0
			for i in [$Control / Pressure, $Control / hello4, $Control / hello8, $Control / hello9]:
				i.visible = false
				
		elif MiniGameType == 2:
			General.remove_item(42, 1, 1)
			General.remove_item(44, 2, 1)
				
			
			General.add_item(45, 1)
			
			General.SoundPlay("res://Music/CentrifugesEnd.mp3")
			queue_free()
		
	if MiniGameType in [0, 1]:
		if Pressure >= 100 or Temp >= 100 or Pressure <= 0:
			General.SoundPlay("res://Music/Explosion0.mp3")
			queue_free()
	elif MiniGameType == 2:
		if Temp >= 85:
			General.SoundPlay("res://Music/Explosion0.mp3")
			queue_free()
	

func VScrollBar_focus_entered():
	General.SoundPlay("res://Music/HitUI.mp3")

func VScrollBar_focus_exited():
	General.SoundPlay("res://Music/HitUI.mp3")


func _on_VScrollBar_gui_input(event):

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				ScrollBarIsPressed = true
				General.SoundPlay("res://Music/HitUI.mp3")
			else:
				ScrollBarIsPressed = false
				General.SoundPlay("res://Music/HitUI.mp3")
