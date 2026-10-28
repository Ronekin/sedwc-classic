extends CanvasLayer
var rnd_b = RandomNumberGenerator.new()
var rnd_s = RandomNumberGenerator.new()
var cost = 1000
var rand_b = rnd_b.randi_range(0, 1000)
var rand_s = rnd_s.randi_range(0, 1000)
var trade_timer = Timer.new()
var count = 1
func _ready():
	start_trade(5)
func _process(delta):
	if $CodeBox / CodeText.text == "":
		count = 1
	cost = int(1000 + General.day_night_animation_second + rand_b + rand_s)
	$Label3.text = "цена 1€: " + str(cost) + " $"

func start_trade(sec):
	trade_timer.connect("timeout", self, "on_tick_trade")
	trade_timer.wait_time = sec
	trade_timer.one_shot = false
	add_child(trade_timer)
	trade_timer.start()
	
func on_tick_trade():
	rnd_b.randomize()
	rnd_s.randomize()
	rand_b = rnd_b.randi_range(0, 1000)
	rand_s = rnd_s.randi_range(0, 1000)


func _on_CodeButton_pressed():
	if General.money >= cost * count:
		General.AchievementGive(29)
		General.euro += count
		General.money -= cost * count
		General.save_save()
func _on_CodeText_text_changed(new_text: String):
	var filtered = ""
	var has_minus = false
	
	for i in range(new_text.length()):
		var c = new_text[i]
		if c >= "0" and c <= "9":
			filtered += c
		elif c == "-" and i == 0 and not has_minus:
			filtered += c
			has_minus = true
	if int(filtered) > 0:
		count = int(filtered)
		$CodeBox / CodeText.text = str(filtered)
		$CodeBox / CodeText.caret_position = filtered.length()


func _on_TouchScreenButton_pressed():
	General.toGameGeneral()

