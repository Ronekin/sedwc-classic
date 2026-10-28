# ShopItems.gd — товары магазина.
#
# Массив записей: item_id (0-based из Items.gd), item_name, price, description.
# Порядок массива задаёт порядок витрины; price — цена покупки в магазине.

extends Reference

const DATA = [
  {
    "item_id": 0,
    "item_name": "Стрела",
    "price": 500,
    "description": "очень ценный предмет. с помощью него вы можете заполучить стенд - особую способность для битв"
  },
  {
    "item_id": 1,
    "item_name": "Диск",
    "price": 500,
    "description": "не менее ценный предмет, но действует наоборот. забирает способность, что-бы вы могли получить новую."
  },
  {
    "item_id": 6,
    "item_name": "Пицца",
    "price": 5,
    "description": "Pizza mozzarella! Pizza mozzarella! Rella rella rella, rella rella rella!"
  },
  {
    "item_id": 10,
    "item_name": "Сталь. Шар",
    "price": 30,
    "description": "Можно использовать как для бросков, так и для квестов. Эффективно."
  },
  {
    "item_id": 4,
    "item_name": "Рокакака",
    "price": 3500,
    "description": "Сбрасывает вашу расу"
  },
  {
    "item_id": 2,
    "item_name": "Слом. диск",
    "price": 250,
    "description": "Диск который сломался."
  },
  {
    "item_id": 5,
    "item_name": "Зол. Рока",
    "price": 10000,
    "description": "При использование не имея стенда дарует SOFT&WET(90%)\nWonder Of U(10% и если при себе > 20к$)"
  }
]
