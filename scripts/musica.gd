extends Node

const _CANCIONES: Dictionary = {
	
	'vals' = [preload('res://musica/vals.ogg'), true],
	'game_over' = [preload('res://musica/game_over.ogg'), false]
	
}

@onready var _player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS	
	
	add_child.call_deferred(_player)
	
	set_cancion('vals')

var cancion: StringName: set = set_cancion


func set_cancion(nueva_cancion: StringName) -> void:
	
	if nueva_cancion == cancion: return
	
	cancion = nueva_cancion
	
	_player.stream = _CANCIONES[nueva_cancion][0]
	_player.stream.loop = _CANCIONES[nueva_cancion][1]
	
	while not _player.is_inside_tree():
		await get_tree().process_frame
		
	_player.play()
