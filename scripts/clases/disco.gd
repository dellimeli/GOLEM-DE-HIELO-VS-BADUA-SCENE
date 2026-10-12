extends Node2D
class_name Disco

@export var nombre: StringName = ''
@export var salud: int = 5: set = set_salud

@export var drops: Array[Drop]

func _init() -> void:
	
	var area: Area2D = Area2D.new()
	var hitbox: CollisionShape2D = CollisionShape2D.new()
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = 50.0
	hitbox.shape = shape
	
	area.set_collision_mask_value(1, false)
	area.set_collision_layer_value(1, false)
	area.set_collision_layer_value(2, true)
	area.set_collision_mask_value(4, true)
	
	area.body_entered.connect(_estrella)
	
	add_child.call_deferred(area)
	area.add_child.call_deferred(hitbox)

func _tirar_a_golem(velocidad: float) -> void:
	
	if salud == 0: return
	
	var estrella: RigidBody2D = global.ESTRELLA.instantiate()
	var angulo: float = get_angle_to(global.golem.global_position)
	
	estrella.objetivo = 'golem'
	
	
	estrella.global_position = global_position
	estrella.linear_velocity = velocidad * Vector2.from_angle(angulo)
	
	get_tree().root.add_child.call_deferred(estrella)

func set_salud(nueva_salud: int) -> void:
	
	nueva_salud = max(nueva_salud, 0)
	
	if salud == nueva_salud: return
	salud = nueva_salud
	
	if salud == 0:
		
		for d in drops:
			
			var drop: Objeto = Objeto.new(d.textura, d.nombre)
			
			drop.global_position = global_position + Vector2(randf_range(-100, 100), 0)
			
			get_tree().root.add_child.call_deferred(drop)
			
		
		queue_free()


func _estrella(estrella: Node2D) -> void:
	
	estrella.queue_free()
	salud -= 1



	
	
	
	
	
