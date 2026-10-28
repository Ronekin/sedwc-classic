extends Node2D
var TimeDa = 0.0
var Details = []
export var ColumnCount = 8
export var Speed: float = 2






func _ready():
	for i in ColumnCount:
		var fafa: Sprite = Sprite.new()
		fafa.texture = load("res://Textures/Details/LoveTrain.png")
		fafa.scale *= 2
		
		var fafafa: Sprite = fafa.duplicate()
		fafafa.scale *= 0.5
		fafafa.modulate = Color("000000")
		fafafa.show_behind_parent = true
		fafa.add_child(fafafa)
		
		var sedwc_da_da: Sprite = Sprite.new()
		sedwc_da_da.texture = load("res://Textures/Light.png")
		sedwc_da_da.scale = Vector2(0.07, 0.7)
		sedwc_da_da.modulate = Color("fff98c")
		sedwc_da_da.modulate.a = 0.6
		
		var mena_elisey_zastavlae_rabotat = CanvasItemMaterial.new()
		mena_elisey_zastavlae_rabotat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		sedwc_da_da.material = mena_elisey_zastavlae_rabotat
		
		fafa.add_child(sedwc_da_da)
		
		add_child(fafa)
		Details.append(fafa)



func _process(delta):
	TimeDa += delta * 180 * Speed
	if TimeDa >= 360:
		TimeDa = TimeDa - 360
	for i in Details.size():
		var angle: float = TimeDa + (i * (360 / ColumnCount))
		if angle > 360:
			angle = angle - 360
		
		
		var angle_in_radians: float = deg2rad(angle)
		var direction = Vector2(cos(angle_in_radians), sin(angle_in_radians))
		
		
		
		Details[i].position = direction * 30
		Details[i].position.y -= 50
		if Details[i].position.y + 50 > 0:
				Details[i].z_index = 5
		else:
				Details[i].z_index = 0

