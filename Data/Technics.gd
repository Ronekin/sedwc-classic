# Technics.gd — техники.
#
# Ключ и techic_number — 0-based (0..7). Поля: index, stand_power_bonus,
# hand_damage_bonus, hp_bonus, abilities (теги способностей).
# Ветки применения техник — в NewClasses/Abilities/TechnicAbility.gd.

extends Reference

const DATA = {
  "0": {
    "index": "None",
    "stand_power_bonus": 0.0,
    "hand_damage_bonus": 0.0,
    "hp_bonus": 0.0,
    "abilities": []
  },
  "1": {
    "index": "SPIN",
    "stand_power_bonus": 0.0,
    "hand_damage_bonus": 0.0,
    "hp_bonus": 0.0,
    "abilities": [
      "spin",
      "spin_ball"
    ]
  },
  "2": {
    "index": "PERFECT SPIN",
    "stand_power_bonus": 0.0,
    "hand_damage_bonus": 0.0,
    "hp_bonus": 0.0,
    "abilities": [
      "spin",
      "spin_ball",
      "infinite_spin"
    ]
  },
  "3": {
    "index": "COMBAT MASTER",
    "stand_power_bonus": 0.0,
    "hand_damage_bonus": 0.0,
    "hp_bonus": 0.0,
    "abilities": [
      "dash",
      "combo"
    ]
  },
  "4": {
    "index": "VAMPIRISM DIO",
    "stand_power_bonus": 0.0,
    "hand_damage_bonus": 0.0,
    "hp_bonus": 0.0,
    "abilities": [
      "vampire"
    ]
  },
  "5": {
    "index": "PILARMEN KARS",
    "stand_power_bonus": 0.0,
    "hand_damage_bonus": 0.0,
    "hp_bonus": 0.0,
    "abilities": [
      "pillarman"
    ]
  },
  "6": {
    "index": "SWORDMASTER",
    "stand_power_bonus": 0.0,
    "hand_damage_bonus": 0.0,
    "hp_bonus": 0.0,
    "abilities": [
      "sword"
    ]
  },
  "7": {
    "index": "",
    "stand_power_bonus": 1.0,
    "hand_damage_bonus": 1.0,
    "hp_bonus": 100.0,
    "abilities": [
      "sword",
      "combo"
    ]
  }
}
