# Items.gd — таблица предметов SEDWC Classic.
#
# Ключ словаря — публичный 0-based ID предмета (0..46). Поля:
# item_name (короткое имя), description (описание в инвентаре),
# message_name/message_suffix (текст сообщения о получении/потере).
#
# Цены магазина лежат в ShopItems.gd, а не здесь: один и тот же предмет может
# продаваться в разных местах по разной цене.
#
# Моддинг: новый предмет добавляйте в конец, существующие ID не меняйте —
# они записаны в сохранениях, квестах и турнирных дропах. 25/26 — головы
# Дио/Дьяволо, 29 — квестовый предмет. Читает Data/SedwcContent.gd.

extends Reference

const DATA = {
  "0": {
    "item_name": "стрела",
    "description": "активационный\nквестовый",
    "message_name": "Стрелы",
    "message_suffix": ""
  },
  "1": {
    "item_name": "диск",
    "description": "активационный\nквестовый",
    "message_name": "Диски",
    "message_suffix": ""
  },
  "2": {
    "item_name": "слом.диск",
    "description": "квестовый",
    "message_name": "Сломанные Диски",
    "message_suffix": ""
  },
  "3": {
    "item_name": "Стрела удачи",
    "description": "скорро...",
    "message_name": "Стрелы удачи",
    "message_suffix": ""
  },
  "4": {
    "item_name": "рокакака",
    "description": "активационный",
    "message_name": "Рокакаки",
    "message_suffix": ""
  },
  "5": {
    "item_name": "зол.рокакака",
    "description": "удал. техники",
    "message_name": "Золотые Рокакаки",
    "message_suffix": ""
  },
  "6": {
    "item_name": "пицца",
    "description": "квестовый",
    "message_name": "Пиццы",
    "message_suffix": ""
  },
  "7": {
    "item_name": "святая рука",
    "description": "активационный",
    "message_name": "Руки Святого Трупа",
    "message_suffix": ""
  },
  "8": {
    "item_name": "стрела реквиема",
    "description": "скоро...",
    "message_name": "Стрелы реквиема",
    "message_suffix": ""
  },
  "9": {
    "item_name": "святое ребро",
    "description": "активационный",
    "message_name": "Ребра Святого Трупа",
    "message_suffix": ""
  },
  "10": {
    "item_name": "стальной шар",
    "description": "квестовый",
    "message_name": "Стальные Шары",
    "message_suffix": ""
  },
  "11": {
    "item_name": "пробка",
    "description": "активационный",
    "message_name": "Пробки",
    "message_suffix": ""
  },
  "12": {
    "item_name": "заряж.пробка",
    "description": "квестовый",
    "message_name": "Заряженные Пробки",
    "message_suffix": ""
  },
  "13": {
    "item_name": "спин-шар",
    "description": "активационный",
    "message_name": "Особые Стальные Шары",
    "message_suffix": ""
  },
  "14": {
    "item_name": "святой таз",
    "description": "активационный",
    "message_name": "Таз Святого Трупа",
    "message_suffix": ""
  },
  "15": {
    "item_name": "Записка",
    "description": "активационный",
    "message_name": "Записка с секретом спина",
    "message_suffix": ""
  },
  "16": {
    "item_name": "Святой глаз",
    "description": "активационный",
    "message_name": "Глаз святого трупа",
    "message_suffix": ""
  },
  "17": {
    "item_name": "Диск Дио",
    "description": "активационный",
    "message_name": "Диск с душой дио",
    "message_suffix": ""
  },
  "18": {
    "item_name": "Дневник Дио",
    "description": "активационный",
    "message_name": "Дневник дио",
    "message_suffix": ""
  },
  "19": {
    "item_name": "Кость дио",
    "description": "активационный",
    "message_name": "Кость дио",
    "message_suffix": ""
  },
  "20": {
    "item_name": "Зел. ребёнок",
    "description": "скоро...",
    "message_name": "Зелённый ребёнок",
    "message_suffix": ""
  },
  "21": {
    "item_name": "Фишка души",
    "description": "активационный",
    "message_name": "Фишки душ",
    "message_suffix": ""
  },
  "22": {
    "item_name": "Диск джотаро",
    "description": "скоро...",
    "message_name": "Диск джотаро",
    "message_suffix": ""
  },
  "23": {
    "item_name": "Фишка силы",
    "description": "активационный",
    "message_name": "Фишки cилы",
    "message_suffix": ""
  },
  "24": {
    "item_name": "Фишка защиты",
    "description": "активационный",
    "message_name": "Фишки защиты",
    "message_suffix": ""
  },
  "25": {
    "item_name": "Голова Дьяв.",
    "description": "квестовый",
    "message_name": "Голова Дьяволо",
    "message_suffix": ""
  },
  "26": {
    "item_name": "Голова Дио",
    "description": "квестовый",
    "message_name": "Голова Дио",
    "message_suffix": ""
  },
  "27": {
    "item_name": "Микросхема",
    "description": "квестовый",
    "message_name": "Старые Микросхемы",
    "message_suffix": ""
  },
  "28": {
    "item_name": "Чип",
    "description": "активационный",
    "message_name": "Чип",
    "message_suffix": ""
  },
  "29": {
    "item_name": "Подарок",
    "description": "Подождите",
    "message_name": "Подарок",
    "message_suffix": ""
  },
  "30": {
    "item_name": "Трава",
    "description": "Контрабанда",
    "message_name": "Травы",
    "message_suffix": " Грамм"
  },
  "31": {
    "item_name": "5000$",
    "description": "Денежная купюра",
    "message_name": "",
    "message_suffix": ""
  },
  "32": {
    "item_name": "Stone musk",
    "description": "каменная маска",
    "message_name": "Stone musk",
    "message_suffix": ""
  },
  "33": {
    "item_name": "ржавое железо",
    "description": "крафтовый",
    "message_name": "Ржавое железо",
    "message_suffix": ""
  },
  "34": {
    "item_name": "свинец",
    "description": "Металлолом",
    "message_name": "Свинец",
    "message_suffix": ""
  },
  "35": {
    "item_name": "кусок кремния",
    "description": "кремний",
    "message_name": "кремний",
    "message_suffix": ""
  },
  "36": {
    "item_name": "банка фосфора",
    "description": "фосфор",
    "message_name": "фосфор",
    "message_suffix": ""
  },
  "37": {
    "item_name": "банка электролита",
    "description": "электролит",
    "message_name": "электролит",
    "message_suffix": ""
  },
  "38": {
    "item_name": "чертёж мини ядерн. реактора",
    "description": "чертёж",
    "message_name": "",
    "message_suffix": ""
  },
  "39": {
    "item_name": "чертёж термо ядерн. реактора",
    "description": "чертёж",
    "message_name": "",
    "message_suffix": ""
  },
  "40": {
    "item_name": "рудный уран",
    "description": "рудный уран",
    "message_name": "сырой уран",
    "message_suffix": ""
  },
  "41": {
    "item_name": "обогащённый уран 235",
    "description": "рудный уран",
    "message_name": "уран 235",
    "message_suffix": ""
  },
  "42": {
    "item_name": "царская водка",
    "description": "царская водка",
    "message_name": "",
    "message_suffix": ""
  },
  "43": {
    "item_name": "сульфидная руда",
    "description": "сульфидн. руда",
    "message_name": "",
    "message_suffix": ""
  },
  "44": {
    "item_name": "шлам",
    "description": "шлам",
    "message_name": "",
    "message_suffix": ""
  },
  "45": {
    "item_name": "кусок паладия",
    "description": "паладий",
    "message_name": "",
    "message_suffix": ""
  },
  "46": {
    "item_name": "5 евро",
    "description": "Европейская валюта",
    "message_name": "5 евро",
    "message_suffix": ""
  }
}
