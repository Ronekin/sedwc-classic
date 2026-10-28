extends Node2D

onready var oblako = preload("res://Scenes/OblakaShee.tscn")
var random = RandomNumberGenerator.new()
var timer = Timer.new()

func _ready():
	add_child(timer)
	$CanvasLayer / Control / Node2D / BG / AnimationPlayer.seek(General.day_night_animation_second)
	random.randomize()
	$CanvasLayer / Control / Egg.frame = 0
	if General.time != "night":
		oblako_spawn()
	
func _on_TouchScreenButton_pressed():
	$CanvasLayer / Control / Egg.frame += 1
	if $CanvasLayer / Control / Egg.frame == 4:
		General.stand_number = 6
		General.save_save()
		Transition.change_scene("res://GeneralGameScenes/MorioMap.tscn", "White")
	random.randomize()
	var random_number = random.randf()
	var animation = $CanvasLayer / Control / AnimationPlayer.get_animation("HitEgg")
	if random_number > 0 and random_number <= 0.5:
		animation.track_set_key_value(0, 0, 20)
	else:
		animation.track_set_key_value(0, 0, - 20)
	$CanvasLayer / Control / AnimationPlayer.play("HitEgg")
	$CanvasLayer / Control / AudioStreamPlayer.play()
	$CanvasLayer / Control / AudioStreamPlayer.pitch_scale = random.randf_range(0.8, 1.2)
	
func _on_TouchScreenButton2_pressed():

	General.toGameGeneral()

func oblako_spawn():
	timer.stop()
	if General.time != "night":
		var oblako_inst = oblako.instance()
		$CanvasLayer / Control.add_child(oblako_inst)
		$CanvasLayer / Control.add_child(oblako_inst)
	if not timer.is_connected("timeout", self, "oblako_spawn"):
		timer.connect("timeout", self, "oblako_spawn")
	timer.wait_time = random.randi_range(5, 8)
	timer.one_shot = true
	timer.start()
