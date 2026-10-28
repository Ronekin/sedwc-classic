extends AudioStreamPlayer

var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	theme_resong()

func _physics_process(delta):
	if get_tree().current_scene.name == "BlackScreen" or get_tree().current_scene.name == "GeneralMenu":
		stream_paused = true

func theme_resong(scene_name = get_tree().current_scene.name):
	stop()
	playing = false
	if scene_name == "MorioMap":
		var random_idx = str(random.randi_range(1, 4))
		play_song("DefaultMapTheme" + random_idx)
	if scene_name == "TournirEnemyArena":
		var random_idx = str(random.randi_range(1, 2))
		play_song("Tournir" + random_idx)
	elif scene_name == "TrainingArena":
		play_song("KaikaiKitanTheme")
	elif scene_name == "DefaultEnemyArena" or scene_name == "TrainingArena" or scene_name == "BullingEnemyArena":
		var random_idx = str(random.randi_range(1, 4))
		play_song("FightingMapTheme" + random_idx)
	elif scene_name == "TuskAct4Bd":
		play_song("BDTheme")
	else:
		play_song(scene_name)
	


func play_song(song):
	if song == "DefaultMapTheme1":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/GeneralTheme1.mp3")
		stream = track
		playing = true
	elif song == "DefaultMapTheme2":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/GeneralTheme2.mp3")
		stream = track
		playing = true
	elif song == "DefaultMapTheme3":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/GeneralTheme3.mp3")
		stream = track
		playing = true
	elif song == "DefaultMapTheme4":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/GeneralTheme4.mp3")
		stream = track
		playing = true
	elif song == "FightingMapTheme1":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/FightingTheme1.mp3")
		stream = track
		playing = true
	elif song == "FightingMapTheme2":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/FightingTheme2.mp3")
		stream = track
		playing = true
	elif song == "FightingMapTheme3":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/FightingTheme3.mp3")
		stream = track
		playing = true
	elif song == "FightingMapTheme4":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/FightingTheme3.mp3")
		stream = track
		playing = true
	elif song == "Tournir1":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/Tournir1.mp3")
		stream = track
		playing = true
	elif song == "Tournir2":
		var track = AudioStreamMP3.new()
		track.loop = true
		track = load("res://Music/Tournir2.mp3")
		stream = track
		playing = true
	elif song == "BDTheme":
		var track = AudioStreamMP3.new()
		track.loop = false
		track = load("res://Music/BdTheme.mp3")
		stream = track
		playing = true
	else:
		var track_path = "res://Music/" + song + ".mp3"
		if not ResourceLoader.exists(track_path):
			return
		var track = load(track_path)
		if track == null: return
		track.loop = true

		stream = track
		volume_db = 0
		if song == "L_Theme":
			play(65)
		elif song == "Crucified_theme":
			play(60 + 58)
			volume_db = 10
		else:
			play(0)

func _on_GENERAL_MUSIC_PLAYER_finished():
	theme_resong()
