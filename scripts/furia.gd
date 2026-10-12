extends Area2D

@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	animacion()

func animacion() -> void:
	
	var tween: Tween = create_tween()
	
	tween.tween_property(sprite, 'scale:y', 1.5 if sprite.scale.y == 1.0 else 1.0, 0.2)
	
	tween.finished.connect(animacion)



func _golem_entro(golem: Node2D) -> void:
	golem.furia = 4.0
	
	queue_free()
