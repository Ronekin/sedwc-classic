extends Control

signal use_move_vector

var velocity = Vector2.ZERO
var joystick_active = false
var move_vector = Vector2.ZERO

func _input(event):
	
	
	var move_x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	var move_y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	
	if move_x > 0: General.direct = "Right"
	elif move_x < 0: General.direct = "Left"
	if move_y < 0: General.direct = "Up"
	elif move_y > 0: General.direct = "Down"
	
	if move_x != 0 or move_y != 0:
		move_vector = Vector2(move_x, move_y).normalized()
	
	if event is InputEventScreenTouch or event is InputEventScreenDrag or move_x != 0 or move_y != 0:
		if $Node2D.is_pressed() and event.position.x < 320 and event.position.y > 80:
			joystick_active = true
			$Node2D / JoustickCenter.global_position = event.position
			move_vector = (limit_calculate_vector(event.position) * 10).floor() / 10

			if move_vector.x > 0 and move_vector.y < 0.5 and move_vector.y > - 0.5:
				General.direct = "Right"
			elif move_vector.x < 0 and move_vector.y < 0.5 and move_vector.y > - 0.5:
				General.direct = "Left"
					
			if move_vector.y > 0 and move_vector.x < 0.5 and move_vector.x > - 0.5:
				General.direct = "Down"
			elif move_vector.y < 0 and move_vector.x < 0.5 and move_vector.x > - 0.5:
				General.direct = "Up"
	
	if event is InputEventScreenTouch or event is InputEventScreenDrag or (move_x == 0 and move_y == 0):
		if $Node2D.is_pressed() == false and (move_x == 0 and move_y == 0):
			joystick_active = false
			$Node2D / JoustickCenter.position = Vector2(55, 55)
			move_vector = Vector2.ZERO

func _physics_process(delta):
	emit_signal("use_move_vector", move_vector)
	
func calculate_move_vector(position):
	var texture_center = $Node2D.position + Vector2(77, 77)
	return (position - texture_center).normalized()
	
func limit_calculate_vector(position):
	var texture_center = $Node2D.position + Vector2(77, 77)
	var limit = 55
	
	if texture_center.distance_to(position) > limit:
		var direction = (position - texture_center).normalized()
		var new_position = texture_center + direction * limit
		$Node2D / JoustickCenter.global_position = new_position
		return (new_position - texture_center).normalized()

	else:
		$Node2D / JoustickCenter.global_position = position
		return calculate_move_vector(position)
