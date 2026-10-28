extends Label

func _ready():
	$SFX3.pressed = General.sfx_enabled

func _physics_process(delta):
	General.sfx_enabled = $SFX3.pressed
