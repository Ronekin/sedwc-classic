# Achievements.gd — достижения.
#
# id — 0-based; name/description — тексты; condition — порог условия
# (убийства, время, деньги и т.п.); completed — стартовое значение (обычно
# false). Конкретную проверку и выдачу задаёт код через AchievementGive(id).

extends Reference

const DATA = [
  {
	"id": 0,
	"name": "Первая кровь!",
	"description": "Совершите своё первое убийство!",
	"condition": 1,
	"completed": false
  },
  {
	"id": 1,
	"name": "Рэмпэйдж!",
	"description": "Совершите 5 убийств!",
	"condition": 5,
	"completed": false
  },
  {
	"id": 2,
	"name": "Ненависть к вечеринкам",
	"description": "Совершите 50 убийств!",
	"condition": 50,
	"completed": false
  },
  {
	"id": 3,
	"name": "Чёрный мечник",
	"description": "Совершите 100 убийств!",
	"condition": 100,
	"completed": false
  },
  {
	"id": 4,
	"name": "Моё имя - Смерть",
	"description": "Совершите 1000 убийств!",
	"condition": 1000,
	"completed": false
  },
  {
	"id": 5,
	"name": "Время быстро летит!",
	"description": "Наиграйте своей первый час.",
	"condition": 1,
	"completed": false
  },
  {
	"id": 6,
	"name": "Я могу остановится в любой момент",
	"description": "Наиграйте 10 часов",
	"condition": 10,
	"completed": false
  },
  {
	"id": 7,
	"name": "Ещё чучуть и всё!",
	"description": "Наиграйте 50 часов",
	"condition": 50,
	"completed": false
  },
  {
	"id": 8,
	"name": "Полпути к безумию",
	"description": "Наиграйте 100 часов",
	"condition": 100,
	"completed": false
  },
  {
	"id": 9,
	"name": "Седвс - моя жизнь!",
	"description": "Наиграйте 250 часов",
	"condition": 250,
	"completed": false
  },
  {
	"id": 10,
	"name": "Первый блин комом.",
	"description": "Умрите в первый раз",
	"condition": 1,
	"completed": false
  },
  {
	"id": 11,
	"name": "Всё нормально, наверное.",
	"description": "умрите 10 раз",
	"condition": 10,
	"completed": false
  },
  {
	"id": 12,
	"name": "Фидер",
	"description": "Умрите 50 раз",
	"condition": 50,
	"completed": false
  },
  {
	"id": 13,
	"name": "press f to respect",
	"description": "Умрите 100 раз",
	"condition": 100,
	"completed": false
  },
  {
	"id": 14,
	"name": "Эгида Бессмертия",
	"description": "Умрите 1000 раз",
	"condition": 1000,
	"completed": false
  },
  {
	"id": 15,
	"name": "Немного мало",
	"description": "Заработайте 10к$",
	"condition": 10000,
	"completed": false
  },
  {
	"id": 16,
	"name": "Стартовый капитал",
	"description": "Заработайте 25к$",
	"condition": 25000,
	"completed": false
  },
  {
	"id": 17,
	"name": "Долларовая лихорадка",
	"description": "Заработайте 100к$",
	"condition": 100000,
	"completed": false
  },
  {
	"id": 18,
	"name": "Благословление мидаса",
	"description": "Заработайте 250к$",
	"condition": 250000,
	"completed": false
  },
  {
	"id": 19,
	"name": "Золотой век",
	"description": "Заработайте 1млн$",
	"condition": 1000000,
	"completed": false
  },
  {
	"id": 20,
	"name": "Шизофрения",
	"description": "Заполучите King Crimson",
	"condition": 1,
	"completed": false
  },
  {
	"id": 21,
	"name": "23-ий президент сша",
	"description": "Заполучите D4C",
	"condition": 1,
	"completed": false
  },
  {
	"id": 22,
	"name": "Это Реквием.",
	"description": "Заполучите GER",
	"condition": 1,
	"completed": false
  },
  {
	"id": 23,
	"name": "Слияние двоих",
	"description": "Заполучите Soft&Wet",
	"condition": 1,
	"completed": false
  },
  {
	"id": 24,
	"name": "Бивень действовать 4",
	"description": "Заполучите Tusk Act 4",
	"condition": 1,
	"completed": false
  },
  {
	"id": 25,
	"name": "Достижение рая",
	"description": "Заполучите Made in Heaven",
	"condition": 1,
	"completed": false
  },
  {
	"id": 26,
	"name": "Над небесами",
	"description": "Заполучите The World Over Heaven",
	"condition": 1,
	"completed": false
  },
  {
	"id": 27,
	"name": "Ты не достигнешь меня!",
	"description": "Заполучите Wounder of U",
	"condition": 1,
	"completed": false
  },
  {
	"id": 28,
	"name": "Надёжный",
	"description": "Выполните задание",
	"condition": 1,
	"completed": false
  },
  {
	"id": 29,
	"name": "Капитализм",
	"description": "Приобритите что нибудь в магазине",
	"condition": 1,
	"completed": false
  },
  {
	"id": 30,
	"name": "Моя прелесть!",
	"description": "Заполучите золотую рокакаку",
	"condition": 1,
	"completed": false
  },
  {
	"id": 31,
	"name": "ГолдРокаМания",
	"description": "Заполучите 50 золотых рокакак",
	"condition": 50,
	"completed": false
  },
  {
	"id": 32,
	"name": "Злой дух?",
	"description": "Заполучите свой первый стенд",
	"condition": 1,
	"completed": false
  },
  {
	"id": 33,
	"name": "Духо-Выносяшка",
	"description": "Используйте диск впервые",
	"condition": 1,
	"completed": false
  },
  {
	"id": 34,
	"name": "Выпустите художника из подвала!",
	"description": "Разгадайте секрет качественных текстур",
	"condition": 1,
	"completed": false
  },
  {
	"id": 35,
	"name": "Жожо-фаг",
	"description": "Используйте стрелу 1000 раз",
	"condition": 1000,
	"completed": false
  },
  {
	"id": 36,
	"name": "Gang-Star",
	"description": "Окажитесь в Италии",
	"condition": 1,
	"completed": false
  },
  {
	"id": 37,
	"name": "Я не безумец!",
	"description": "Достигните 100 этапа в турнире",
	"condition": 100,
	"completed": false
  },
  {
	"id": 38,
	"name": "Иди потрогай траву!",
	"description": "Наиграйте 1000 часов",
	"condition": 1000,
	"completed": false
  },
  {
	"id": 39,
	"name": "Невозможное достижение",
	"description": "Невозможное возможно",
	"condition": 1,
	"completed": false
  }
]
