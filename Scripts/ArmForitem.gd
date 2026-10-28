extends Sprite

func _physics_process(delta):
	if General.item_in_arm != "0":
		$Item.frame = int(General.item_in_arm) - 1
