# Stands.gd — стенды.
#
# Ключ и stand_number — 0-based (0..27). Поля: index (имя для кода),
# direction (сторона анимации), frame, abilities (теги способностей).
# Сцены и анимации стендов лежат отдельно; здесь только данные.
#
# abilities — полный список способностей стенда. Базовые теги
# summon/default_attack/barrage есть у каждого стенда; дальше идут особые
# приёмы (time_stop, nail, hole, heal, ...). StandAbility регистрирует ровно
# этот список, поэтому новая способность добавляется сюда и в код стенда.

extends Reference

const DATA = {
  "0": {
    "index": "None",
    "direction": "",
    "frame": 0,
    "abilities": []
  },
  "1": {
    "index": "TheWorld",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_stop"
    ]
  },
  "2": {
    "index": "StarPlatinum",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_stop"
    ]
  },
  "3": {
    "index": "GoldExp",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "heal",
      "tree"
    ]
  },
  "4": {
    "index": "TuskAct1",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "nail",
      "hole"
    ]
  },
  "5": {
    "index": "TuskAct2",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "nail",
      "hole"
    ]
  },
  "6": {
    "index": "EhosAct1",
    "direction": "Right",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "nail",
      "glush"
    ]
  },
  "7": {
    "index": "EhosAct0",
    "direction": "Horizontal",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "sound"
    ]
  },
  "8": {
    "index": "KingCrimson",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_erase",
      "chop"
    ]
  },
  "9": {
    "index": "TuskAct3",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "nail",
      "hole"
    ]
  },
  "10": {
    "index": "Soft&Wet",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "bubble"
    ]
  },
  "11": {
    "index": "TuskAct4",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "nail",
      "hole"
    ]
  },
  "12": {
    "index": "HzStand",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_stop"
    ]
  },
  "13": {
    "index": "KKDopio",
    "direction": "Right",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "chop"
    ]
  },
  "14": {
    "index": "ShadowTW",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_stop",
      "knife"
    ]
  },
  "15": {
    "index": "TWGH",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_stop",
      "overwrite"
    ]
  },
  "16": {
    "index": "TWOH",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_stop",
      "overwrite"
    ]
  },
  "17": {
    "index": "GER",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "heal",
      "return_to_zero"
    ]
  },
  "18": {
    "index": "SCRetro",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_accelerate"
    ]
  },
  "19": {
    "index": "SCRetroW",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_accelerate"
    ]
  },
  "20": {
    "index": "WhiteSnake",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "disc"
    ]
  },
  "21": {
    "index": "BallBreaker",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "spin"
    ]
  },
  "22": {
    "index": "CMoon",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "gravity"
    ]
  },
  "23": {
    "index": "MIH",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "time_accelerate"
    ]
  },
  "24": {
    "index": "GER",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "heal",
      "return_to_zero"
    ]
  },
  "25": {
    "index": "D4C",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "dimension"
    ]
  },
  "26": {
    "index": "WoU",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "calamity"
    ]
  },
  "27": {
    "index": "HeirophantGreen",
    "direction": "Left",
    "frame": 0,
    "abilities": [
      "summon",
      "default_attack",
      "barrage",
      "emerald_barrage"
    ]
  }
}
