# TournirFloor.gd — сетка этапов турнира.
#
# Показывает пройденные/текущие этапы по General.tournir_record и
# tournament_lvl. Награды и генерация врагов — в турнирных сервисах.

extends Control

var page = 0
var forced_stage = 0
var current = false
const max_page = 9


onready var dc = preload("res://Textures/CurrentStage.png")
onready var cc = preload("res://Textures/CompleteStage2.png")
onready var f = preload("res://Textures/CurrentStage2.png")
onready var cf = preload("res://Textures/CompleteStage.png")


var floor_buttons = []
var floor_labels = []

func _ready():
	
	floor_buttons = [
		$Floor, 
		$Floor2, 
		$Floor3, 
		$Floor4, 
		$Floor5, 
		$Floor6, 
		$Floor7, 
		$Floor8, 
		$Floor9, 
		$Floor10
	]
	
	
	for i in range(floor_buttons.size()):
		var button = floor_buttons[i]
		var label = null
		
		
		if button.has_node("Floor"):
			label = button.get_node("Floor")
		elif button.get_child_count() > 0:
			
			for child in button.get_children():
				if child is Label:
					label = child
					break
		
		floor_labels.append(label)
		
		
		if label:
			label.text = str(i + page * 10)
		else:
			
			printerr("Не найден лейбл для кнопки ", i)
	
	
	update_button_labels_and_visibility()

func _process(delta):
	
	if page > 0:
		$PrevPage.visible = true
	else:
		$PrevPage.visible = false
	
	if page < max_page:
		$NextPage.visible = true
	else:
		$NextPage.visible = false
	
	
	update_floor_textures()
	update_text_visibility()

func update_floor_textures():
	
	for i in range(floor_buttons.size()):
		var floor_button = floor_buttons[i]
		var global_stage_index = i + page * 10
		
		
		if global_stage_index == General.tournament_lvl:
			
			if i == 9:
				floor_button.normal = cf
			else:
				floor_button.normal = cc
		else:
			
			if i == 9:
				floor_button.normal = dc
			else:
				floor_button.normal = f

func update_text_visibility():
	
	for i in range(floor_labels.size()):
		var label = floor_labels[i]
		if label:
			var global_stage_index = i + page * 10
			
			
			if global_stage_index == General.tournament_lvl:
				label.visible = false
			else:
				label.visible = true

func _on_PrevPage_pressed():
	if page > 0:
		page -= 1
		update_button_labels_and_visibility()

func _on_NextPage_pressed():
	if page < max_page:
		page += 1
		update_button_labels_and_visibility()


func _on_Floor_pressed():
	forced_stage = 0 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		
		update_text_visibility()

func _on_Floor2_pressed():
	forced_stage = 1 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor3_pressed():
	forced_stage = 2 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor4_pressed():
	forced_stage = 3 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor5_pressed():
	forced_stage = 4 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor6_pressed():
	forced_stage = 5 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor7_pressed():
	forced_stage = 6 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor8_pressed():
	forced_stage = 7 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor9_pressed():
	forced_stage = 8 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()

func _on_Floor10_pressed():
	forced_stage = 9 + page * 10
	if General.tournament_lvl <= 99 and forced_stage <= General.tournir_record:
		General.tournament_lvl = forced_stage
		update_text_visibility()
func update_button_labels_and_visibility():
	
	for i in range(floor_labels.size()):
		var label = floor_labels[i]
		if label:
			var global_stage_index = i + page * 10
			label.text = str(global_stage_index)
	
	
	update_text_visibility()
