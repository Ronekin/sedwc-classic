extends Node

var achievements = []






func _process(_delta):
	if achievements == null or achievements.size() == 0:
		var general = get_node_or_null("/root/General")
		if general != null:
			achievements = general.content_db().get_achievements()
