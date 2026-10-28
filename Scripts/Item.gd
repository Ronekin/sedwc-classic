# Item.gd — предмет на карте: появление, анимация и подбор.
#
# Подбор обрабатывается ItemBoxService; этот скрипт отвечает только за
# визуальное состояние и позицию предмета в сцене.

extends StaticBody2D

onready var sprite = $Sprite
onready var animation = $AnimationPlayer
var timer = Timer.new()
onready var sprite2 = $Sprite2
var random = RandomNumberGenerator.new()
var position_check = [Vector2(0, 0)]
var random_frame = [6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 0, 2, 2, 10, 10]
var made_in_heaven = 1

func _ready():
	visible = false
	timer.connect("timeout", self, "respawn")
	timer.wait_time = 20 * made_in_heaven
	timer.one_shot = true
	add_child(timer)
	timer.start()
func _process(delta):
	if General.stand_number == 24:
		made_in_heaven = 0.5
	else:
		made_in_heaven = 1
func respawn():
	visible = true
	random.randomize()
	var random_index = random.randi_range(0, random_frame.size() - 1)
	var random_value = random_frame[random_index]
	sprite2.z_index = 0
	sprite.z_index = 1
	sprite.frame_coords.x = random_value
	animation.play("Idle")

func _on_Area2D_area_entered(area):
	if area.is_in_group("ItemBox") and visible == true:
		General.SoundPlay("res://Music/Metal_da0.mp3")
		visible = false
		General.add_item(sprite.frame_coords.x, 1, 1)
		timer.stop()
		if not timer.is_connected("timeout", self, "respawn"):
			timer.connect("timeout", self, "respawn")
		timer.wait_time = 20
		timer.one_shot = true
		timer.start()
	
