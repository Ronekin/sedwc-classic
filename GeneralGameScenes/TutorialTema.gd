extends CanvasLayer

var tema = ""
var podtema = ""

func _ready():
	$General / Text.text = General.tutorial_text
	match int(floor(General.tutorial_id)):
		1: tema = "Предметы"
		2: tema = "НПС"
		3: tema = "Враги"
		4: tema = "Стенды"
		5: tema = "Карта"
		6: tema = "Настройки"
		7: tema = "Инвентарь"
		8: tema = "Квесты"
		10: tema = "Магазин"
		11: tema = "Тренировка"
		12: tema = "Интерфейс"
		13: tema = "Разработчики"
	if tema == "Предметы":
		match General.tutorial_id:
			1.1: podtema = "Стрела"
			1.2: podtema = "Диск"
			1.21: podtema = "Сломанный Диск"
			1.3: podtema = "Рокакака"
			1.4: podtema = "Стальной Шар"
			1.5: podtema = "Пробка"
			1.6: podtema = "Пицца"
			1.7: podtema = "Заряженная пробка"
			1.8: podtema = "Специальный стальной шар"
			1.9: podtema = "Рука Святого Трупа"
			1.91: podtema = "Ребро Святого Трупа"
			1.92: podtema = "Таз Святого Трупа"
	elif tema == "НПС":
		match General.tutorial_id:
			2.1: podtema = "Джотаро"
			2.2: podtema = "Джонни"
			2.3: podtema = "Джайро"
			2.4: podtema = "Пуччи"
			2.5: podtema = "Странник"
	elif tema == "Враги":
		match int((General.tutorial_id - floor(General.tutorial_id)) * 10):
			1: podtema = "Тестовый враг"
			2: podtema = "Хулиган"
	elif tema == "Стенды":
		match General.tutorial_id:
			4.1: podtema = "Зе Ворлд"
			4.2: podtema = "Голд Экспириенс"
			4.3: podtema = "Кинг Кримзон"
			4.4: podtema = "Таск Акт 1"
			4.5: podtema = "Таск Акт 2"
			4.6: podtema = "Таск Акт 3"
			4.7: podtema = "Эхос Акт 0"
			4.8: podtema = "Эхос Акт 1"
			4.9: podtema = "Софт Анд Вет"
			4.91: podtema = "Стар Платинум"
	elif tema == "Настройки":
		match General.tutorial_id:
			6.1: podtema = "Настройки Игры"
			6.2: podtema = "FAQ"
			6.3: podtema = "Возвращение в меню"
			6.4: podtema = "Выход из настроек"
			6.5: podtema = "Аудио"
	elif tema == "Инвентарь":
		match General.tutorial_id:
			1: podtema = "Предметы инвентаря"
			2: podtema = "Статистика Игрока"
	elif tema == "Квесты":
		match General.tutorial_id:
			8.1: podtema = "Панель Квеста"
			8.2: podtema = "Подробности Квеста"
			8.3: podtema = "Выполнение Квеста"
	elif tema == "Интерфейс":
		match General.tutorial_id:
			12.1: podtema = "Свободный Интерфейс"
			12.2: podtema = "Боевой Интерфейс"
			12.3: podtema = "Тренировочный Интерфейс"
			12.4: podtema = "Боевая Панель"
	
	if podtema == "Стрела":
		$General / Sprite.frame = 0
	elif podtema == "Диск":
		$General / Sprite.frame = 4
	elif podtema == "Сломанный Диск":
		$General / Sprite.frame = 10
	elif podtema == "Рокакака":
		$General / Sprite.frame = 8
	elif podtema == "Стальной Шар":
		$General / Sprite.frame = 5
	elif podtema == "Пробка":
		$General / Sprite.frame = 9
	elif podtema == "Пицца":
		$General / Sprite.frame = 1
	elif podtema == "Заряженная пробка":
		$General / Sprite.frame = 2
	elif podtema == "Специальный стальной шар":
		$General / Sprite.frame = 6
	elif podtema == "Рука Святого Трупа":
		$General / Sprite.frame = 3
	elif podtema == "Ребро Святого Трупа":
		$General / Sprite.frame = 7
	elif podtema == "Таз Святого Трупа":
		$General / Sprite.frame = 11
	
	elif podtema == "Джонни":
		$General / Sprite.frame = 12
	elif podtema == "Джайро":
		$General / Sprite.frame = 13
	elif podtema == "Пуччи":
		$General / Sprite.frame = 14
	elif podtema == "Странник":
		$General / Sprite.frame = 15
	
	elif podtema == "Зе Ворлд":
		$General / Sprite.frame = 16
	elif podtema == "Стар Платинум":
		$General / Sprite.frame = 17
	elif podtema == "Голд Экспириенс":
		$General / Sprite.frame = 18
	elif podtema == "Кинг Кримзон":
		$General / Sprite.frame = 23
	elif podtema == "Таск Акт 1":
		$General / Sprite.frame = 19
	elif podtema == "Таск Акт 2":
		$General / Sprite.frame = 20
	elif podtema == "Таск Акт 3":
		$General / Sprite.frame = 25
	elif podtema == "Эхос Акт 0":
		$General / Sprite.frame = 22
	elif podtema == "Эхос Акт 1":
		$General / Sprite.frame = 21
	elif podtema == "Софт Анд Вет":
		$General / Sprite.frame = 24
	
	elif podtema == "Тестовый враг":
		$General / Sprite.frame = 26
	elif podtema == "Хулиган":
		$General / Sprite.frame = 27
	
	elif podtema == "Настройки Игры":
		$General / Sprite.frame = 28
	elif podtema == "FAQ":
		$General / Sprite.frame = 29
	elif podtema == "Аудио":
		$General / Sprite.frame = 30
	
	elif tema == "Инвентарь":
		$General / Sprite.frame = 31
		
	elif podtema == "Панель Квеста":
		$General / Sprite.frame = 32
	elif podtema == "Подробности Квеста":
		$General / Sprite.frame = 33
	elif podtema == "Выполнение Квеста":
		$General / Sprite.frame = 34
	
	elif podtema == "Свободный Интерфейс":
		$General / Sprite.frame = 35
	elif podtema == "Боевой Интерфейс":
		$General / Sprite.frame = 36
	elif podtema == "Тренировочный Интерфейс":
		$General / Sprite.frame = 37
	elif podtema == "Боевая Панель":
		$General / Sprite.frame = 40
	
	elif tema == "Магазин":
		$General / Sprite.frame = 39
	elif tema == "Тренировка":
		$General / Sprite.frame = 38
	elif tema == "Разработчики":
		$General / Sprite.frame = 41
	
	if tema != "Карта" and tema != "Тренировка" and tema != "Магазин" and tema != "Инвентарь" and tema != "Разработчики":
		$AllMap.visible = false
		$General / Text.visible = true
		$General / Sprite.visible = true
		$General / Tema.text = tema + ": " + podtema
		$General / TouchScreenButton.position = Vector2(359, 425)
	elif tema == "Карта":
		$AllMap.visible = true
		$General / Text.visible = false
		$General / Sprite.visible = false
		$General / Tema.text = tema
		$General / TouchScreenButton.position = Vector2(107, 425)
	else:
		$AllMap.visible = false
		$General / Text.visible = true
		$General / Sprite.visible = true
		$General / Tema.text = tema
		$General / TouchScreenButton.position = Vector2(359, 425)

func _on_TouchScreenButton_pressed():
	if General.last_scene in ["MorioMap", "Jail", "Italy", "Germany"]:
		General.toGameGeneral()
	else:
		
		Transition.change_scene("res://GeneralGameScenes/TutorialGeneral.tscn", "Black")
