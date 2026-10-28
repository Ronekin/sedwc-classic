# GeneralAudioService.gd — разовые SFX и настройки аудиошин.
#
# Контракт: sound_play() использует AudioStreamPlayer и SoundsDa на General;
# громкость и включение читаются из настроек General.

extends Reference


func sound_play(general, link_to_sound: String, Dop: Dictionary = {}):
	var sound = load(link_to_sound)
	if sound:
		if sound.get("loop") and ("Loop" in Dop) == false:
			sound.loop = false
		var da: AudioStreamPlayer = AudioStreamPlayer.new()
		da.stream = sound
		var final_volume = general.db_sfx
		if "Volume_db" in Dop:
			final_volume += Dop["Volume_db"]
		da.volume_db = final_volume
		da.play()
		general.add_child(da)
		if "ID" in Dop:
			general.SoundsDa[Dop["ID"]] = da
		yield(da, "finished")
		if is_instance_valid(da):
			da.queue_free()
			if "ID" in Dop:
				general.SoundsDa.erase(Dop["ID"])


func audio_settings_check(general):
	var bus_sfx = AudioServer.get_bus_index("SFX")
	var bus_mus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus_sfx, not general.sfx_enabled)
	AudioServer.set_bus_mute(bus_mus, not general.music_enabled)
	AudioServer.set_bus_volume_db(bus_sfx, general.db_sfx)
	AudioServer.set_bus_volume_db(bus_mus, general.db_music)
