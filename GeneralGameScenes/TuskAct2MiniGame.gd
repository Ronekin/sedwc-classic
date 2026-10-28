extends Node2D

onready var oblako = preload("res://Scenes/OblakaShee.tscn")
onready var listya = preload("res://Scenes/Listya.tscn")
var random = RandomNumberGenerator.new()
var timer = Timer.new()
var timer_listya = Timer.new()

func _ready():
	add_child(timer)
	add_child(timer_listya)
	$CanvasLayer / Control / Node2D / BG / AnimationPlayer.seek(General.day_night_animation_second)
	General.gold_listya_count = 0
	random.randomize()
	if General.time != "night":
		oblako_spawn()
	listya_spawn()

func _on_TouchScreenButton2_pressed():
	Transition.change_scene("res://GeneralGameScenes/MorioMap.tscn", "Black")

func oblako_spawn():
	timer.stop()
	if General.time != "night":
		var oblako_inst = oblako.instance()
		$CanvasLayer / Control.add_child(oblako_inst)
		$CanvasLayer / Control.add_child(oblako_inst)
	if not timer.is_connected("timeout", self, "oblako_spawn"):
		timer.connect("timeout", self, "oblako_spawn")
	timer.wait_time = random.randi_range(3, 5)
	timer.one_shot = true
	timer.start()

func listya_spawn():
	timer_listya.stop()
	var listya_inst = listya.instance()
	var random_number = random.randf()
	var random_pos = Vector2.ZERO
	if random_number > 0 and random_number <= 0.5:
		random_pos = random.randi_range( - 200, - 75)
	else:
		random_pos = random.randi_range(75, 200)
	listya_inst.global_position = $CanvasLayer / Control / Tree1.global_position + Vector2(random_pos, 0)
	$CanvasLayer / Control.add_child(listya_inst)
	if not timer_listya.is_connected("timeout", self, "listya_spawn"):
		timer_listya.connect("timeout", self, "listya_spawn")
	timer_listya.wait_time = random.randi_range(0, 1)
	timer_listya.one_shot = true
	timer_listya.start()

func _physics_process(delta):
	$CanvasLayer / Control / Label3.text = str(General.gold_listya_count) + "/5"
