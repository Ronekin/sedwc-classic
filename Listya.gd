extends KinematicBody2D

var velocity = Vector2(0, 1)
var random = RandomNumberGenerator.new()
var speed = 2500

func _ready():
	random.randomize()
	var random_number = random.randf()
	if random_number > 0 and random_number <= 0.3:
		$Sprite.frame = 1
	if random_number > 0.3 and random_number <= 0.6:
		$Sprite.frame = 2
	if random_number > 0.6 and random_number <= 0.8:
		$Sprite.frame = 3
	if random_number > 0.8 and random_number <= 1:
		$Sprite.frame = 0
	yield(get_tree().create_timer(10), "timeout")
	$AnimationPlayer.play("DeathDefault")

func _physics_process(delta):
	move_and_slide(speed * delta * velocity)

func _on_TouchScreenButton_pressed():
	if $Sprite.frame == 0 and $AnimationPlayer.current_animation != "DeathGold":
		General.gold_listya_count += 1
		if General.gold_listya_count == 5:
			Transition.change_scene("res://GeneralGameScenes/MorioMap.tscn", "White")
			General.tree_gold_mini_game_completed += 1
			General.message_spawn("Center", "Кол-во идеальных листочков: \n" + str(General.tree_gold_mini_game_completed * 5) + "/25")
			General.save_save()
		$AnimationPlayer.play("DeathGold")
	elif $Sprite.frame != 0 and $AnimationPlayer.current_animation != "DeathDefault":
		General.gold_listya_count = 0
		General.toGameGeneral()

		General.message_spawn("Center", "Вы не попали по идеальному листочку. Попробуйте еще раз.")
		$AnimationPlayer.play("DeathDefault")
