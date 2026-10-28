extends Control

func _ready():
	$HScrollBar.value = General.db_music

func _physics_process(delta):
	General.db_music = $HScrollBar.value
