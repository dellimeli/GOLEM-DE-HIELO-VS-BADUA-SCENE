extends RigidBody2D
class_name Objeto

var sprite: Sprite2D

func _init(textura: Texture2D, nombre: StringName) -> void:
	name = nombre
	
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)
	set_collision_layer_value(5, true)
	set_collision_mask_value(3, true)
	
	sprite = Sprite2D.new()
	sprite.texture = textura
	add_child.call_deferred(sprite)
	
	var hitbox: CollisionShape2D = CollisionShape2D.new()
	
	hitbox.shape = RectangleShape2D.new()
	add_child.call_deferred(hitbox)

func recoger() -> void:
	
	global.golem.objetos.append(self)

var _seno: float = randf_range(0.0,  1.0)

func _process(delta: float) -> void:
	
	
	sprite.scale.x = sin(_seno + Time.get_ticks_msec() * 0.002) 
	
	
	
