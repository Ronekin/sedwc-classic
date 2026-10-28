extends Control
export var ID: int







func _ready():
	$Node2D / AchievPanel.name = "AchievPanel" + str(ID)







func AnimationFinished(anim_name):
	queue_free()
