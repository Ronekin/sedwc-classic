extends Control

export var Numb = - 1
export var Type = 0






func _ready():
	pass







func Button_Pressed():
	$"../../..".ItemSelect(Numb, Type)
