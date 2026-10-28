# Enemies.gd — обычные враги и Cars.
#
# Ключ — имя врага (General.EnemyName). Поля: HP, Money, Exp, Items.
# Items — массив [0-based item_id, шанс 0..1, подпись дропа].
# Турнирные боссы живут в TournamentPools.gd, не здесь.
#
# Моддинг: новый враг — запись здесь и класс-наследник NewClasses/Enemy.gd.
# Существующие имена не переименовывайте: на них ссылаются сцены.

extends Reference

const DATA = {
  "DefaultEnemy": {
	"HP": 75,
	"Money": 50,
	"Exp": 20,
	"Items": []
  },
  "dio": {
	"HP": 500,
	"Money": 250,
	"Exp": 50,
	"Items": [
	  [
		19,
		0.1,
		"кость дио"
	  ],
	  [
		26,
		1.0,
		"голова Дио"
	  ]
	]
  },
  "zeck": {
	"HP": 100,
	"Money": 50,
	"Exp": 40,
	"Items": []
  },
  "bucciarati": {
	"HP": 200,
	"Money": 250,
	"Exp": 50,
	"Items": []
  },
  "cyborg": {
	"HP": 250,
	"Money": 400,
	"Exp": 100,
	"Items": [
	  [
		35,
		0.4,
		"кремний"
	  ],
	  [
		36,
		0.2,
		"фосфор"
	  ],
	  [
		37,
		0.15,
		"электролит"
	  ],
	  [
		38,
		0.1,
		"синий чертёж"
	  ],
	  [
		40,
		0.1,
		"рудн уран"
	  ]
	]
  },
  "IronMan": {
	"HP": 800,
	"Money": 400,
	"Exp": 125,
	"Items": [
	  [
		39,
		0.03,
		"красный чертёж"
	  ],
	  [
		40,
		0.15,
		"рудн уран"
	  ],
	  [
		43,
		0.15,
		"сульфидн руда"
	  ]
	]
  },
  "BullingEnemy": {
	"HP": 100,
	"Money": 50,
	"Exp": 25,
	"Items": []
  },
  "jotaro6": {
	"HP": 700,
	"Money": 250,
	"Exp": 100,
	"Items": []
  },
  "peshi": {
	"HP": 750,
	"Money": 100,
	"Exp": 35,
	"Items": []
  },
  "luka": {
	"HP": 550,
	"Money": 100,
	"Exp": 50,
	"Items": []
  },
  "Diabolo": {
	"HP": 550,
	"Money": 350,
	"Exp": 175,
	"Items": [
	  [
		25,
		1.0,
		"голова Дьяволо"
	  ]
	]
  },
  "Cars": {
	"HP": 1000,
	"Money": 0,
	"Exp": 0,
	"Items": []
  }
}
