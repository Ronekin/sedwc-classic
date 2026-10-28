# DialogWindow.gd — окно диалога с ответами.
#
# General.text_dialog хранит текущую реплику, General.answer_1..answer_5 —
# подписи кнопок. Сами тексты лежат в Data/Dialogues.gd; это окно только
# показывает их и проигрывает анимацию появления.
#
# Клики по ответам обрабатывает PanelDialog.gd: он меняет General.text_dialog
# через show_dialog_line() и закрывает окно через close_dialog().
extends Control

onready var window = $Sprite
onready var text = $Sprite / Label
onready var timer = Timer.new()
var enabled_to_skip = false

func _ready():
	General.dialog_activate = true
	text.text = ""
	$Sprite2 / Name.text = General.npc_name
	$AnimationPlayer.play("MovingUp")
	if typeof(General.answer_1) == 4:
		$Sprite / AnswerContainer / AnswerSlot1.visible = true
		$Sprite / AnswerContainer / AnswerSlot1 / TextAnswer.text = General.answer_1
	else:
		$Sprite / AnswerContainer / AnswerSlot1.visible = false
	if typeof(General.answer_2) == 4:
		$Sprite / AnswerContainer / AnswerSlot2.visible = true
		$Sprite / AnswerContainer / AnswerSlot2 / TextAnswer.text = General.answer_2
	else:
		$Sprite / AnswerContainer / AnswerSlot2.visible = false
	if typeof(General.answer_3) == 4:
		$Sprite / AnswerContainer / AnswerSlot3.visible = true
		$Sprite / AnswerContainer / AnswerSlot3 / TextAnswer.text = General.answer_3
	else:
		$Sprite / AnswerContainer / AnswerSlot3.visible = false
	if typeof(General.answer_4) == 4:
		$Sprite / AnswerContainer / AnswerSlot4.visible = true
		$Sprite / AnswerContainer / AnswerSlot4 / TextAnswer.text = General.answer_4
	else:
		$Sprite / AnswerContainer / AnswerSlot4.visible = false
	if typeof(General.answer_5) == 4:
		$Sprite / AnswerContainer / AnswerSlot5.visible = true
		$Sprite / AnswerContainer / AnswerSlot5 / TextAnswer.text = General.answer_5
	else:
		$Sprite / AnswerContainer / AnswerSlot5.visible = false
	
func respawn_or_spawn():
	enabled_skip()
	General.text_speed = 0.05
	$Sprite2 / Name.text = General.npc_name
	if typeof(General.answer_1) == 4:
		$Sprite / AnswerContainer / AnswerSlot1.visible = true
		$Sprite / AnswerContainer / AnswerSlot1 / TextAnswer.text = General.answer_1
	else:
		$Sprite / AnswerContainer / AnswerSlot1.visible = false
	if typeof(General.answer_2) == 4:
		$Sprite / AnswerContainer / AnswerSlot2.visible = true
		$Sprite / AnswerContainer / AnswerSlot2 / TextAnswer.text = General.answer_2
	else:
		$Sprite / AnswerContainer / AnswerSlot2.visible = false
	if typeof(General.answer_3) == 4:
		$Sprite / AnswerContainer / AnswerSlot3.visible = true
		$Sprite / AnswerContainer / AnswerSlot3 / TextAnswer.text = General.answer_3
	else:
		$Sprite / AnswerContainer / AnswerSlot3.visible = false
	if typeof(General.answer_4) == 4:
		$Sprite / AnswerContainer / AnswerSlot4.visible = true
		$Sprite / AnswerContainer / AnswerSlot4 / TextAnswer.text = General.answer_4
	else:
		$Sprite / AnswerContainer / AnswerSlot4.visible = false
	if typeof(General.answer_5) == 4:
		$Sprite / AnswerContainer / AnswerSlot5.visible = true
		$Sprite / AnswerContainer / AnswerSlot5 / TextAnswer.text = General.answer_5
	else:
		$Sprite / AnswerContainer / AnswerSlot5.visible = false
	$Tween.interpolate_property(text, "percent_visible", 0.0, 1.0, len(General.text_dialog) * 0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()
	
func _physics_process(delta):
	if General.dialog_recheck == true:
		text.text = ""
		respawn_or_spawn()
		General.dialog_recheck = false
	if General.dialog_destroy_signal == true:
		$AnimationPlayer.play("MovingDown")
		General.dialog_destroy_signal = false
	if General.dialog_create_signal == true:
		text.text = ""
		$AnimationPlayer.play("MovingUp")
		General.dialog_create_signal = false
	if $Tween.is_active():
		$Sprite / Sprite / AnimationPlayer.play(General.npc_eng_name + "Talk")
		General.text_get_animated = true
		text.text = General.text_dialog
	elif $Tween.is_active() == false and text.text == "":
		$Sprite / Sprite / AnimationPlayer.play(General.npc_eng_name + "Idle")
		General.text_get_animated = false
		text.text = ""
	elif $Tween.is_active() == false and text.text != "":
		$Sprite / Sprite / AnimationPlayer.play(General.npc_eng_name + "Idle")
		General.text_get_animated = false
		text.text = General.text_dialog
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "MovingDown":
		General.answer_1 = 0
		General.answer_2 = 0
		General.answer_3 = 0
		General.answer_4 = 0
		General.answer_5 = 0
		General.text_dialog = ""
		General.npc_name = ""
		General.npc_eng_name = ""
		General.dialog_destroy_signal = false
		General.dialog_activate = false
		queue_free()
	elif anim_name == "MovingUp":
		text.text = ""
		respawn_or_spawn()

func _on_TextureButton_pressed():
	$Tween.playback_speed = 1000
	yield($Tween, "tween_all_completed")
	$Tween.playback_speed = 1
		
func enabled_skip():
	enabled_to_skip = true
