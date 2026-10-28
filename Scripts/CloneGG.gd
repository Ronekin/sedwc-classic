extends KinematicBody2D

var velocity = Vector2(0, 1)
var direct = Vector2.ZERO
var speed = 10000
onready var boom_effect = preload("res://Scenes/Explosion.tscn")
var boom_start = false

func _process(delta):
	if boom_start == false:
		$AnimationPlayer.play("Walk")
func _physics_process(delta):
	direct = (General.player_pos - global_position).normalized()
	if boom_start == false:
		move_and_slide(delta * speed * direct)
		






func _on_Area2D_area_entered(area):
	var new_exp = boom_effect.instance()
	if area.is_in_group("AttackPlayerArea"):
		$AnimationPlayer.play("BOOM")
		add_child(new_exp)
