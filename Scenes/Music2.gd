extends Label

func _ready():
	$SFX4.pressed = General.music_enabled

func _physics_process(delta):
		General.music_enabled = $SFX4.pressed

