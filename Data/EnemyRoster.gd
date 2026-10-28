# EnemyRoster.gd — шаблоны тренировочных врагов.
#
# Каждая запись: HP, ATTACK_COUNT, RAGE. Используется тренировочной ареной;
# это не турнирные пулы и не обычные враги из Enemies.gd.

extends Reference

const DATA = [
  {
    "HP": 75,
    "ATTACK_COUNT": 3,
    "RAGE": 1.5
  },
  {
    "HP": 999999999,
    "ATTACK_COUNT": 0,
    "RAGE": 0
  },
  {
    "HP": 30,
    "ATTACK_COUNT": 2,
    "RAGE": 1
  },
  {
    "HP": 750,
    "ATTACK_COUNT": 3,
    "RAGE": 3.5
  }
]
