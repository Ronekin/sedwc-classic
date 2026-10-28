# NPC.gd — NPC на карте: спрайт, зона взаимодействия и диалог.
#
# NPC_Index связывает сцену с данными/диалогом; логика диалога — в
# DialogService, здесь остаются только отображение и вход в зону.

extends StaticBody2D

export var NPC_Index = 0
export var _position = - 1
var ToRight: bool
var TimerDa: float

func _ready():
	
	
	var vis = false
	var scene_name = get_tree().current_scene.name
	if NPC_Index == 25:
		# Валентайн появляется в MorioMap сразу, а в остальных сценах —
		# только пока активен один из сюжетных этапов 12.x.
		vis = true
		if scene_name != "MorioMap":
			for quest_id in [12.3, 12.31, 12.32, 12.33, 12.34, 12.35]:
				if General.search_id(quest_id) != - 1:
					vis = false
					break
		if scene_name == "Italy" or scene_name == "MorioMap":
			visible = vis
		elif scene_name == "Rom":
			vis = false
			for quest_id in [12.3, 12.31, 12.32, 12.33, 12.34, 12.35]:
				if General.search_id(quest_id) != - 1:
					vis = true
					break
			visible = vis
		else:
			visible = not vis
	else:
		vis = true
		visible = true
	$Area2D / CollisionShape2D.disabled = not visible
	$CollisionShape2D.disabled = not visible
	
	
	
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.frame = NPC_Index
	$Sprite.hframes = 13
	$Sprite.vframes = 3
	var will_be = true
	match NPC_Index:
		7: $Sprite.frame = 8
		20: $Sprite.frame = 9
		21: $Sprite.frame = 13
		
		22: $Sprite.frame = 14
		23: $Sprite.frame = 15
		24: $Sprite.frame = 16
		25: $Sprite.frame = 17
		26: $Sprite.frame = 18
		27: $Sprite.frame = 19
		28: $Sprite.frame = 20
		29: $Sprite.frame = 19
		30: $Sprite.frame = 12
		31: $Sprite.frame = 21
		32: $Sprite.frame = 22
		33: $Sprite.frame = 23
		34: $Sprite.frame = 24
		35: $Sprite.frame = 25
		36: $Sprite.frame = 26
		37: $Sprite.frame = 24
		38: $Sprite.frame = 27
		39: $Sprite.frame = 19
		_: will_be = false
			
	if will_be:
		for i in $Area2D.get_groups():
			if $Area2D.is_in_group(i):
				$Area2D.remove_from_group(i)
		$Area2D.add_to_group("NPC")


func _process(delta):
	TimerDa += delta
	if TimerDa > 0.1:
		if global_position.x > General.player_pos.x and ToRight:
			ToRight = false
			scale.x *= - 1
		elif global_position.x < General.player_pos.x and not ToRight:
			ToRight = true
			scale.x *= - 1
		TimerDa = 0
	if NPC_Index == 39 and General.merchant_info["spawned"] == true:
		if _position == General.merchant_info["position"]:
			visible = true
			$Area2D / CollisionShape2D.disabled = false
			$CollisionShape2D.disabled = false
		else:
			visible = false
			$Area2D / CollisionShape2D.disabled = true
			$CollisionShape2D.disabled = true

func _on_Area2D_area_entered(area):
	if area.is_in_group("ItemBox"):
		$Sprite.material.set_shader_param("width", 1)

		


func _on_Area2D_area_exited(area):
	if area.is_in_group("ItemBox"):
		$Sprite.material.set_shader_param("width", 0)
