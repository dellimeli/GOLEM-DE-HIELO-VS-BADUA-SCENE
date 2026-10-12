extends RigidBody2D

@onready var sprite: Sprite2D = $sprite

var objetivo: String = 'enemigo'

enum tipos {nula, cero, media, una}

var tipo: tipos = tipos.nula: 
	set(nuevo_tipo):
		tipo = nuevo_tipo

func _ready() -> void:

	if objetivo == 'golem':
		set_collision_mask_value(1, true)
		set_collision_layer_value(2, true)
		sprite.modulate = Color.RED
	elif objetivo == 'enemigo':
		set_collision_mask_value(2, true)
		set_collision_layer_value(4, true)
		
	
	await get_tree().create_timer(10).timeout
	
	var tween: Tween = create_tween()
	
	tween.tween_property(sprite, 'modulate:a', 0.0, 1.0)
	
	tween.tween_callback(_morir)
	

func _process(_delta: float) -> void:
	
	if xy.obtener_coordenada(global_position) != global.golem.coordenada:
		queue_free()

func _morir() -> void:
	
	global.golem.estrellas -= 1	
	queue_free()
	
	
