extends Control

func _ready():
	$HScrollBar.value = General.db_sfx

func _physics_process(delta):
	General.db_sfx = $HScrollBar.value
	
