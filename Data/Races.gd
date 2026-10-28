# Races.gd — расы.
#
# Ключ и race_number — 0-based (0..5). Поля: index (имя для кода),
# hp (базовое HP расы), passives (теги пассивных способностей).
# Ветки рас — в NewClasses/Abilities/SpecAbility.gd.

extends Reference

const DATA = {
  "0": {
    "index": "human",
    "hp": 100.0,
    "passives": []
  },
  "1": {
    "index": "vampire",
    "hp": 125.0,
    "passives": [
      "vampire_regen",
      "blood"
    ]
  },
  "2": {
    "index": "pilarmen",
    "hp": 150.0,
    "passives": [
      "pillarman_regen"
    ]
  },
  "3": {
    "index": "evo pilarmen",
    "hp": 175.0,
    "passives": [
      "pillarman_regen",
      "evolved"
    ]
  },
  "4": {
    "index": "perfect creature",
    "hp": 200.0,
    "passives": [
      "perfect_creature"
    ]
  },
  "5": {
    "index": "cyborg",
    "hp": 100.0,
    "passives": [
      "cyborg",
      "battery"
    ]
  }
}
