extends Camera2D

var tween: Tween

signal fin_de_transicion

func _ready() -> void: process_mode = PROCESS_MODE_ALWAYS


func mover(coordenada: Vector2i, _coordenada_anterior: Vector2i) -> void:
	
	global.golem.funcionar = false
	
	await get_tree().create_timer(1.0).timeout
	
	if is_instance_valid(tween) and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	
	tween.tween_property(self, 'global_position', get_viewport_rect().size * Vector2(coordenada), 1.0)

	await get_tree().create_timer(2.0).timeout
	
	global.golem.funcionar = true
	
	fin_de_transicion.emit()
