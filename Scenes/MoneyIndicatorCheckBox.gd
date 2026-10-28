extends CheckBox

func _ready():
	pressed = General.money_indicator_cratco

func _physics_process(delta):
	General.money_indicator_cratco = pressed
