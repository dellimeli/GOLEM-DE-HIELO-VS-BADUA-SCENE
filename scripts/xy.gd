extends Node

const PANTALLA: Vector2 = Vector2(1152, 648)

@onready var area_optima: Area2D = preload('res://scenes/area_optima.tscn').instantiate()

func _ready() -> void:
	add_child.call_deferred(area_optima)


func obtener_coordenada(posicion_global: Vector2) -> Vector2i:
	
	posicion_global /= PANTALLA
	
	return Vector2i(floor(posicion_global.x), floor(posicion_global.y))
	
	
