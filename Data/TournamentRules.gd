# TournamentRules.gd — формулы и таблицы турнира.
#
# hp_*/damage_* — база и рост за уровень; exp_* — опыт; drop_chance_* — шансы;
# type_pool/strong_type_chance — элитные типы; level_drops/special_drops —
# 0-based item_id; money_rewards — уровни 0..9, money_reward_* — уровни 10+;
# reward_categories — категории наград. Формулы читает TournamentEnemyFactory.

extends Reference

const DATA = {
  "hp_boss_base": 250,
  "hp_boss_per_level": 15,
  "hp_regular_base": 60,
  "hp_regular_per_level": 6,
  "damage_boss_base": 20,
  "damage_boss_per_level": 4,
  "damage_regular_base": 8,
  "damage_regular_per_level": 2,
  "exp_per_level": 5,
  "exp_boss_bonus": 100,
  "exp_regular_bonus": 10,
  "drop_chance_strong_base": 0.5,
  "drop_chance_boss_base": 0.2,
  "type_pool": [
	"ярый",
	"танк",
	"шустрый"
  ],
  "strong_type_chance": 0.2,
  "tank_hp_multiplier": 1.5,
  "true_hp_multiplier": 1.2,
  "true_damage_multiplier": 1.3,
  "level_drops": [
	{
	  "min_level": 20,
	  "rolls": [
		{
		  "threshold": 0.8,
		  "item_id": 0,
		  "count": 2
		},
		{
		  "threshold": 0.6,
		  "item_id": 1,
		  "count": 2
		},
		{
		  "threshold": 0.4,
		  "item_id": 2,
		  "count": 2
		}
	  ]
	},
	{
	  "min_level": 10,
	  "rolls": [
		{
		  "threshold": 0.8,
		  "item_id": 0,
		  "count": 1
		},
		{
		  "threshold": 0.6,
		  "item_id": 1,
		  "count": 1
		}
	  ]
	},
	{
	  "min_level": 2,
	  "rolls": [
		{
		  "threshold": 0.9,
		  "item_id": 0,
		  "count": 1
		},
		{
		  "threshold": 0.8,
		  "item_id": 1,
		  "count": 1
		}
	  ],
	  "exclusive": true
	}
  ],
  "special_drops": {
	"Cars": {
	  "item_id": 46,
	  "chance": 0.4,
	  "zero_drop_chance": true
	},
	"Jotaro": {
	  "item_id": 18,
	  "chance": 0.5,
	  "zero_drop_chance": true
	}
  },
  "money_rewards": {
	"0": 300,
	"1": 500,
	"2": 1000,
	"3": 2000,
	"4": 5000,
	"5": 5000,
	"6": 12500,
	"7": 15000,
	"8": 17500,
	"9": 20000
  },
  "money_reward_level_start": 10,
  "money_reward_base": 20000,
  "money_reward_per_level": 1000,
  "money_reward_special": {
	"15": 25500,
	"20": 25500,
	"25": 25500,
	"30": 25500
  },
  "reward_categories": {
	"0": "arrow",
	"1": "disk",
	"2": "broken_disk",
	"4": "roka",
	"5": "roka",
	"6": "pizzas"
  }
}
