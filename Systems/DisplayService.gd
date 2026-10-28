# DisplayService.gd — единая настройка окна и масштабирования.
#
# Игра рисуется в базовом разрешении 640×360, а окно растягивает картинку под
# экран. Режим stretch 2D + aspect expand сохраняет пропорции и не оставляет
# чёрных полос: при другом соотношении сторон становится видно больше мира.
#
# На десктопе окно разворачивается на весь экран при запуске. На мобильных
# платформах и в headless-тестах размер окна не трогаем.

extends Reference

const BASE_SIZE = Vector2(640, 360)


func apply_startup_window(tree) -> void:
	if tree == null:
		return
	tree.set_screen_stretch(
		SceneTree.STRETCH_MODE_2D,
		SceneTree.STRETCH_ASPECT_EXPAND,
		BASE_SIZE,
		1
	)
	var os_name = OS.get_name()
	if os_name == "Server" or os_name == "Android" or os_name == "iOS":
		return
	OS.window_resizable = true
	OS.set_window_maximized(true)
