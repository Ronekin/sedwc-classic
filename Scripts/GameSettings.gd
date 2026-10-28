extends CanvasLayer
var custom_text = ""
func _ready():
	$Control2 / CameraSpeedRed / HScrollBar.value = General.camera_speed
	$Control2 / CameraScale / HScrollBar.value = 2 - General.camera_scale.x

func _physics_process(delta):
	General.camera_speed = $Control2 / CameraSpeedRed / HScrollBar.value
	General.camera_scale = Vector2(2 - $Control2 / CameraScale / HScrollBar.value, 2 - $Control2 / CameraScale / HScrollBar.value)
	
	
func _on_CodeButton_pressed():
	var code = $Control2 / CodeBox / CodeText.text.to_lower()
	if General.general_codes.find(code) != - 1 and General.activate_codes.find(code) == - 1:
		reward_code(code)
		$Control2 / CodeBox / Label2.modulate = Color(24, 98, 0, 255)
		$Control2 / CodeBox / Label2.text = "Код введен успешно!"
		General.activate_codes.append(code)
		General.save_save()
		$Control2 / CodeBox / CodeText.text = ""
	elif General.activate_codes.find(code) != - 1:
		$Control2 / CodeBox / CodeText.text = ""
		$Control2 / CodeBox / Label2.text = "Вы уже ввели этот код."
		$Control2 / CodeBox / Label2.modulate = Color(172, 0, 0, 255)
	else:
		$Control2 / CodeBox / CodeText.text = ""
		$Control2 / CodeBox / Label2.text = "Код неверен. " + custom_text
		$Control2 / CodeBox / Label2.modulate = Color(172, 0, 0, 255)


func _on_BackButton_pressed():
	General.toGameGeneral()

	General.save_save()
	

func _on_CodeText_text_entered(new_text):
	var code = new_text.to_lower()
	if General.general_codes.find(code) != - 1 and General.activate_codes.find(code) == - 1:
		reward_code(code)
		$Control2 / CodeBox / Label2.modulate = Color(24, 98, 0, 255)
		$Control2 / CodeBox / Label2.text = "Код введен успешно!"
		General.activate_codes.append(code)
		General.save_save()
		$Control2 / CodeBox / CodeText.text = ""
	elif General.activate_codes.find(code) != - 1:
		$Control2 / CodeBox / CodeText.text = ""
		$Control2 / CodeBox / Label2.text = "Вы уже ввели этот код."
		$Control2 / CodeBox / Label2.modulate = Color(172, 0, 0, 255)
	else:
		$Control2 / CodeBox / CodeText.text = ""
		$Control2 / CodeBox / Label2.text = "Код неверен. " + custom_text
		$Control2 / CodeBox / Label2.modulate = Color(172, 0, 0, 255)
		custom_text = ""

func reward_code(code):
	if code == "2ktgsubs":
		General.s_coins += 20
	elif code == "summerday":
		General.s_coins += 15
	elif code == "kakafkaloh":
		General.s_coins += 5
	elif code == "spidloh":
		General.add_item(0, 2000)
		General.add_item(1, 2000)
		General.add_item(2, 2000)
		General.play_time = 9659
