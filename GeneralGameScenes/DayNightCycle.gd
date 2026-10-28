extends CanvasModulate

func _ready():
	if $AnimationPlayer.current_animation_position >= 0 and $AnimationPlayer.current_animation_position < 110:
		General.time = "day"
	elif $AnimationPlayer.current_animation_position >= 110 and $AnimationPlayer.current_animation_position < 120:
		General.time = "zakat"
	elif $AnimationPlayer.current_animation_position >= 120 and $AnimationPlayer.current_animation_position < 250:
		General.time = "night"
	elif $AnimationPlayer.current_animation_position >= 250 and $AnimationPlayer.current_animation_position < 280:
		General.time = "rassvet"
	elif $AnimationPlayer.current_animation_position >= 280 and $AnimationPlayer.current_animation_position < 360:
		General.time = "day"

func _physics_process(delta):
	if $AnimationPlayer.current_animation_position >= 0 and $AnimationPlayer.current_animation_position < 110:
		General.time = "day"
	elif $AnimationPlayer.current_animation_position >= 110 and $AnimationPlayer.current_animation_position < 120:
		General.time = "zakat"
	elif $AnimationPlayer.current_animation_position >= 120 and $AnimationPlayer.current_animation_position < 250:
		General.time = "night"
	elif $AnimationPlayer.current_animation_position >= 250 and $AnimationPlayer.current_animation_position < 280:
		General.time = "rassvet"
	elif $AnimationPlayer.current_animation_position >= 280 and $AnimationPlayer.current_animation_position < 360:
		General.time = "day"

func day():
	General.time = "day"

func night():
	General.time = "night"
	
func zakat():
	General.time = "zakat"

func rassvet():
	General.time = "rassvet"

func add_day():
	General.day += 1
	General.save_save()
