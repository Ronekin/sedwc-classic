extends KinematicBody2D

var random = RandomNumberGenerator.new()
var velocity = Vector2(1, 0)
var speed = 2000

func _ready():
	random.randomize()
	var random_number = random.randi_range(60, 130)
	var random_scale = random.randf_range(0.5, 1.0)
	$Sprite.frame = random.randi_range(0, 2)
	$Sprite.scale = Vector2(random_scale, random_scale)
	global_position = Vector2( - 120, random_number)
	
func _physics_process(delta):
	move_and_slide(speed * velocity * delta)
	if global_position.x >= 820:
		queue_free()
