extends Area2D


func _ready() -> void:
	
	while global.golem == null:
		await get_tree().process_frame
	
	global.golem.cambio_de_coordenada.connect(barrer)


func barrer(coordenada: Vector2i, coordenada_anterior: Vector2i) -> void:
	
	_habilitar_objetos(false, coordenada_anterior)

	await global.camara.fin_de_transicion
	
	_habilitar_objetos(true, coordenada)


func _habilitar_objetos(si: bool, coordenada: Vector2i) -> void:

	global_position = xy.PANTALLA * Vector2(coordenada)
	
	for i in 3: await get_tree().physics_frame

	var objetos: Array = get_overlapping_bodies() + get_overlapping_areas()
	
	for o in objetos:
		
		if o == self:
			continue
		
		var padre: Node = o
		
		while padre.get_parent() != null and padre.get_parent() != get_tree().current_scene:
			padre = padre.get_parent()

		if padre == global.golem:
			continue

		if padre == get_tree().current_scene:
			continue
		if padre is Window:
			continue


		padre.visible = si
		padre.set_process(si)
		padre.set_physics_process(si)
	
	
