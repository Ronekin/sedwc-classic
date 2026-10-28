# TournirSelect.gd — экран выбора турнирного этапа.
#
# Читает General.tournir_record/tournament_lvl и переключает этапы.
# Генерация врагов и награды — в TournamentEnemyFactory/TournamentRewardService.

extends Node2D








func _ready():
	if General.tournir_record < General.tournament_lvl - 1:
		General.tournir_record = General.tournament_lvl - 1







func AllStages_Pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	for i in $CanvasLayer / Control / Floors / ScrollContainer / GridContainer.get_children(): i.queue_free()
	
	var StageNode: PackedScene = preload("res://Scenes/TournirStage.tscn")
	
	
	
	
	
	
	for i in int((General.tournir_record) * 0.1) * 10 + 10:
		var da: Object = StageNode.instance()
		da.Stage = i + 1
		$CanvasLayer / Control / Floors / ScrollContainer / GridContainer.add_child(da)
	for i in 10:
		var baubau = Control.new()
		$CanvasLayer / Control / Floors / ScrollContainer / GridContainer.add_child(baubau)
	$CanvasLayer / Control / Floors / AnimationPlayer.play("FloorShow")


func FloorExit_Pressed():
	General.SoundPlay("res://Music/HitUI.mp3")
	$CanvasLayer / Control / Floors / AnimationPlayer.play("FloorHide")
