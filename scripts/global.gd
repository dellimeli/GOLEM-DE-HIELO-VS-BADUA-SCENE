extends Node

const ESTRELLA: PackedScene = preload('res://scenes/estrella.tscn')

var golem: CharacterBody2D
@onready var camara: Camera2D = preload('res://scenes/camara.tscn').instantiate()

func _ready() -> void:
	
	get_tree().root.add_child.call_deferred(camara)
	
	const grupos: PackedStringArray = ['consumibles', 'disco']
	
	for grupo in grupos:
		
		var nodos: Array[Node] = get_tree().get_nodes_in_group('grupo')
		
		for nodo in nodos:
			var visible: bool = xy.obtener_coordenada(nodo.global_position) == Vector2i.ZERO
			
			nodo.visible = visible
			nodo.set_process(visible)
			nodo.set_physics_process(visible)
			
