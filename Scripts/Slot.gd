extends TextureButton
signal ButtonWillPressed

var item = preload("res://Scenes/ItemInv.tscn")
class_name ItemInvButton




func _physics_process(delta):
	if General.items_inventory.size() >= int(name.substr(4)):
		if General.items_inventory[int(name.substr(4)) - 1].x != 0 and get_child_count() == 0:
			var item_inst = item.instance()
			add_child(item_inst)
func on_button_pressed():
	
	$"../../..".ItemSelect(General.items_inventory[int(name.substr(4)) - 1].x)

	
	var item_inst = item.instance()



				
