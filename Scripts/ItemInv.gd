extends TextureButton
signal ButtonPressed

var item = Vector2()

func _ready():
	$Sprite.frame = General.items_inventory[int(get_parent().name.substr(4)) - 1].x - 1

func _physics_process(delta):
	var item = General.items_inventory[int(get_parent().name.substr(4)) - 1]
	$Sprite.frame = item.x - 1


	if item.y < 1000:
		$Label.text = str(item.y)
	elif item.y >= 1000 and item.y < 1000000:
		$Label.text = str(int(item.y / 1000)) + "K"
	elif item.y >= 1000000:
		$Label.text = str(int(item.y / 1000000)) + "M"
	if $Label.text == "0":
		queue_free()

func _on_Node2D_pressed():
	pass



func _on_Node2D_button_down():
	if General.item_in_arm != str($Sprite.frame + 1):
		connect("ButtonPressed", get_parent(), "on_button_pressed")
		emit_signal("ButtonPressed")
		disconnect("ButtonPressed", get_parent(), "on_button_pressed")
		General.item_in_arm = str($Sprite.frame + 1)
		General.item_arm_message_activate = true
	else:
		General.item_in_arm = "0"
		connect("ButtonPressed", get_parent(), "on_button_pressed")
		emit_signal("ButtonPressed")
		disconnect("ButtonPressed", get_parent(), "on_button_pressed")
