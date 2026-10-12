extends RichTextLabel

var contadores: Dictionary = {'furia': 0.0, 'hielo': 0.0}
@onready var pos_og: float = position.y

func _process(_delta: float) -> void:
	
	
	var posicion: float = 0.0
	var texto: String = ''
	
	for clave in contadores.keys():
		
		if contadores[clave]:
			var color: String
			
			match clave:
				'furia': color = Color.DARK_MAGENTA.to_html(false)
				'hielo': color = Color.AQUA.to_html(false)
			
			texto += '[color=%s]%.2fs[/color]\n' % [color, contadores[clave]]
			posicion -= 24.0
	
	
	visible = texto != ''
	text = texto
	position.y = posicion + pos_og
		
