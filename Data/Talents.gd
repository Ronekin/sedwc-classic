# Talents.gd — деревья талантов по расам.
#
# talents[race_number][talent_id] = [icon_frame, cost, label, effects].
# race_number — 0-based ID расы из Races.gd; talent_id — 0-based ID узла.
# effects — словарь прибавок к Stats (HP, DamageHands, DamageProcent,
# MoveSpeed, Regen, BERSERK, Rage...). Ветки дерева задаются в RaceSkillTree.gd.
# Рас 3 и 4 используют дерево расы 2; у расы 5 (киборг) дерева нет.

extends Reference

const DATA = {
  "0": {
    "0": [
      0,
      1,
      "+10 HP",
      {
        "HP": 10.0
      }
    ],
    "1": [
      0,
      1,
      "+10 HP",
      {
        "HP": 10.0
      }
    ],
    "2": [
      0,
      1,
      "+15 HP",
      {
        "HP": 15.0
      }
    ],
    "3": [
      1,
      1,
      "+1 Damage hands",
      {
        "DamageHands": 1.0
      }
    ],
    "4": [
      1,
      1,
      "+2 Damage hands,\n+10% All damage",
      {
        "DamageHands": 2.0,
        "DamageProcent": 10.0
      }
    ],
    "5": [
      5,
      1,
      "+10% move speed",
      {
        "MoveSpeed": 10.0
      }
    ],
    "6": [
      5,
      1,
      "+10% move speed",
      {
        "MoveSpeed": 10.0
      }
    ],
    "7": [
      5,
      1,
      "+10% move speed",
      {
        "MoveSpeed": 10.0
      }
    ],
    "8": [
      6,
      1,
      "+50% regeneration HP",
      {
        "Regen": 50.0
      }
    ],
    "9": [
      6,
      1,
      "+100% regeneration HP",
      {
        "Regen": 100.0
      }
    ],
    "10": [
      7,
      4,
      "BERSERK MODE\n  HP < 10%:\n   Regen 30% HP\n   Damage x2.5\n   Defence 50%\n   Move Speed x1.5",
      {
        "BERSERK": true
      }
    ],
    "11": [
      8,
      3,
      "накопите ярость нанесением или получением урона:\n   х2 all damage,\n   х1.4 move speed\n(эффект длится 6 sec)",
      {
        "Rage": true
      }
    ],
    "12": [
      9,
      2,
      "+5 sec rage mode duration (11 sec)",
      {
        "Rage+": true
      }
    ]
  },
  "1": {
    "0": [
      0,
      1,
      "+10 HP",
      {
        "HP": 10.0
      }
    ],
    "1": [
      0,
      1,
      "+10 HP",
      {
        "HP": 10.0
      }
    ],
    "2": [
      6,
      1,
      "+10% REGEN HP",
      {
        "Regen": 10.0
      }
    ],
    "3": [
      6,
      1,
      "+10% REGEN HP",
      {
        "Regen": 10.0
      }
    ],
    "4": [
      6,
      1,
      "+10% REGEN HP",
      {
        "Regen": 10.0
      }
    ],
    "5": [
      1,
      1,
      "+1 Damage hands,\n+5% ALL DAMAGE",
      {
        "DamageHands": 1.0,
        "DamageProcent": 5.0
      }
    ],
    "6": [
      1,
      1,
      "+1 Damage hands,\n+5% ALL DAMAGE",
      {
        "DamageHands": 1.0,
        "DamageProcent": 5.0
      }
    ],
    "7": [
      1,
      1,
      "+1 Damage hands,\n+5% ALL DAMAGE",
      {
        "DamageHands": 1.0,
        "DamageProcent": 5.0
      }
    ],
    "8": [
      2,
      1,
      "ваш метаболизм адаптируется к переработке употреблённой крови",
      {
        "VB": true
      }
    ],
    "9": [
      2,
      1,
      "эффективность поглащения крови +100%,\nрегенерация при метобализме +50%",
      {
        "VB+": true
      }
    ],
    "10": [
      2,
      3,
      "контролируйте метаболизм и регенерацию.\nрегенерация намного быстрее",
      {
        "VB++": true
      }
    ],
    "12": [
      3,
      3,
      "атакуйте биологической жидкостью из глаз!",
      {
        "LV": true
      }
    ]
  },
  "2": {
    "0": [
      0,
      1,
      "+5 HP",
      {
        "HP": 5.0
      }
    ],
    "1": [
      0,
      1,
      "+5 HP",
      {
        "HP": 5.0
      }
    ],
    "2": [
      0,
      2,
      "+10 HP",
      {
        "HP": 10.0
      }
    ],
    "3": [
      1,
      3,
      "+2.5 Damage hands",
      {
        "DamageHands": 2.5
      }
    ],
    "4": [
      1,
      4,
      "+3 Damage hands",
      {
        "DamageHands": 3
      }
    ],
    "5": [
      1,
      2,
      "+5% All damage",
      {
        "DamageProcent": 5.0
      }
    ],
    "6": [
      1,
      2,
      "+5% All damage",
      {
        "DamageProcent": 5.0
      }
    ],
    "7": [
      1,
      2,
      "+5% All damage",
      {
        "DamageProcent": 5.0
      }
    ],
    "8": [
      6,
      1,
      "+25% regeneration HP",
      {
        "Regen": 25.0
      }
    ],
    "9": [
      6,
      1,
      "+50% regeneration HP",
      {
        "Regen": 50.0
      }
    ],
    "10": [
      7,
      4,
      "",
      {
        "BERSERK": true
      }
    ],
    "11": [
      8,
      3,
      "",
      {
        "Rage": true
      }
    ],
    "12": [
      9,
      2,
      "",
      {
        "Rage+": true
      }
    ]
  }
}
