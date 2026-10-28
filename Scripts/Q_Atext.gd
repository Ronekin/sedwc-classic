extends Control

func _ready():
	$TextureRect / ScrollContainer / GridContainer / Label.text = General.qa_text

func _on_TextureButton_pressed():
	General.qa_text_activate = false
	queue_free()
