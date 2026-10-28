extends CheckBox

func _ready():
	pressed = General.fps_show_enabled

func _physics_process(delta):
	General.fps_show_enabled = pressed
