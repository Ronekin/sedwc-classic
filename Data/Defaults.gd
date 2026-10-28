# Defaults.gd — стартовые значения General и подсистем.
#
# Ключ — имя поля/словаря; значения копируются при новой игре.
# Не добавляйте сюда поля сохранения без миграции SedwcSaveProfile.gd.

extends Reference

const DATA = {
  "choose_skins": {
    "spin": "default"
  },
  "egg_upgrade": {
    "power": 0,
    "auto_count": 0,
    "auto_power": 0,
    "chance_double": 0
  },
  "merchant_info": {
    "spawned": false,
    "position": -1,
    "type": "material"
  },
  "houses": [
    "Street"
  ],
  "hous_contains": {
    "roof": "",
    "facad": "",
    "windows": ""
  },
  "talents_buff": {
    "attack_damage": 0.0,
    "ability_damage": 0.0,
    "dop_health": 0.0
  },
  "sb_items": {
    "roka": 0,
    "arrow": 0,
    "disc": 0,
    "gold_roka": 0,
    "pizza": 0,
    "broken_disk": 0
  },
  "global_buffs": {
    "johny_awakeng": false
  },
  "current_achiviement": {
    "id": -1,
    "name": "",
    "condition": "",
    "reward_type": "",
    "reward": ""
  },
  "tournir_all_reward_items": {
    "pizzas": 0,
    "disk": 0,
    "broken_disk": 0,
    "arrow": 0,
    "roka": 0
  },
  "twoh_complete_quest": {
    "blood": 0.0,
    "arrow": false,
    "jesus": false,
    "eye": 0,
    "arms": 0,
    "pelvis": false,
    "rib": false,
    "bone": false
  },
  "bonus_player": {
    "health": 0,
    "dmg_gg": 0,
    "dmg_st": 0
  },
  "limit_player": {
    "hp": 0,
    "dmg_gg": 0,
    "dmg_st": 0
  },
  "global_bonus": {
    "money": 1,
    "exp": 1
  },
  "global_debuffs": {
    "hand_fear": false
  },
  "general_codes": [
    "2ktgsubs",
    "summerday",
    "kakafkaloh",
    "spidloh"
  ]
}
