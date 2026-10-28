# TournamentPools.gd — составы турнирных волн.
#
# regular/bosses — словари "имя -> {texture, hframes, vframes, addition}".
# regular_order/boss_order — порядок выбора имён; имена должны совпадать
# с ключами пула. addition — теги особой анимации/поведения.
# Турнирные боссы не добавляются в Enemies.gd.

extends Reference

const DATA = {
  "regular": {
    "хулиган": {
      "texture": "BullingEnemySheet.png",
      "hframes": 8,
      "vframes": 1,
      "addition": []
    },
    "качёк": {
      "texture": "EnemySheet.png",
      "hframes": 8,
      "vframes": 1,
      "addition": []
    },
    "киборг": {
      "texture": "Somebody0.png",
      "hframes": 8,
      "vframes": 2,
      "addition": [
        "new_anim_type"
      ]
    }
  },
  "bosses": {
    "Gyro": {
      "texture": "Gyro.png",
      "hframes": 4,
      "vframes": 3,
      "addition": [
        "new_anim_type"
      ]
    },
    "Jotaro": {
      "texture": "JotaroPart6.png",
      "hframes": 8,
      "vframes": 1,
      "addition": []
    },
    "Valentine": {
      "texture": "FunnyValentain.png",
      "hframes": 8,
      "vframes": 2,
      "addition": [
        "new_anim_type"
      ]
    },
    "Cars": {
      "texture": "Cars.png",
      "hframes": 8,
      "vframes": 2,
      "addition": [
        "new_anim_type"
      ]
    }
  },
  "regular_order": [
    "хулиган",
    "качёк",
    "киборг"
  ],
  "boss_order": [
    "Gyro",
    "Jotaro",
    "Valentine",
    "Cars"
  ]
}
