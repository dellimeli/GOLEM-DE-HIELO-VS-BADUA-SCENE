extends CharacterBody2D

# 1. Señales
signal cambio_de_coordenada(xy: Vector2i, pxy: Vector2i)
signal morir

# 2. Enums
enum estados { quieto, caminar, hielo, caer, saltar, muerto }

# 3. Constantes
const ESTADOS_PERMITIDOS: PackedFloat32Array = [estados.quieto, estados.caminar]
const ESTADOS_INVALIDOS: PackedFloat32Array = [estados.hielo, estados.muerto]

# 4. Nodos @onready
@onready var sonidos = $sonidos
@onready var contadores = $estados
@onready var sprite: Sprite2D = $sprite

# 5. Variables
var estrellas: int = 0: 
	set(nueva_estrella):
		estrellas = clamp(nueva_estrella, 0, 10)

var estado: estados = estados.quieto: set = set_estado
var _estado_anterior: estados = estados.quieto

var furia: float = 0.0: set = set_furia
var _multiplicador: float = 1.0

var coordenada: Vector2i = Vector2.ZERO: set = set_coordenada
var coordenada_anterior: Vector2i = Vector2.DOWN * 753

var tiempo_coyote: float = 0.0
var _cooldown_salto: bool = false

var funcionar: bool = true: 
	set(retener):
		funcionar = retener
		set_process(funcionar)
		set_physics_process(funcionar)
		set_process_input(funcionar)


@onready var gotas_de_elixir = $gui/vida
@onready var _elixir = $gui/vida/elixir.duplicate()
var salud: int = 1: 
	set(nueva_vida):
		
		if estado == estados.muerto:
			return
		
		salud = clamp(nueva_vida, 0, 10)
		if not salud:
			set_estado(estados.muerto)
		
		while gotas_de_elixir.get_children().size() != salud:
			
			if salud > gotas_de_elixir.get_children().size():
				gotas_de_elixir.add_child(_elixir.duplicate())
			else:
				gotas_de_elixir.remove_child(gotas_de_elixir.get_child(-1))
			
			
		
		


var hielo: float = 0.0: 
	set(nuevo_hielo):
		if nuevo_hielo == hielo: return
		hielo = nuevo_hielo
		
		contadores.contadores['hielo'] = hielo
		sprite.modulate.r = 0.0
		
		if not hielo:
			sprite.modulate.r = 1.0
			estado = _estado_anterior

# 6. Métodos de Godot (_ready, _process, etc.)
func _ready() -> void:
	global.golem = self
	cambio_de_coordenada.connect(global.camara.mover)
	
	salud = 10
	
	morir.connect(musica.set_cancion.bind('game_over'))

func _input(event: InputEvent) -> void:
	if estado != estados.hielo and Input.is_physical_key_pressed(KEY_6):
		estado = estados.hielo
	
	if Input.is_physical_key_pressed(KEY_TAB):
		mostrar = not mostrar

func _process(delta: float) -> void:
	furia = move_toward(furia, 0.0, delta)
	hielo = move_toward(hielo, 0.0, delta)
	
	
	
	if estado not in ESTADOS_INVALIDOS and estrellas < 10 and Input.is_action_just_pressed('ui_down'):
		tirar_estrella()
	
	
	coordenada = xy.obtener_coordenada(global_position)

func _physics_process(delta: float) -> void:
	var movimiento: float = 0.0
	var suelo: bool = is_on_floor()
	
	if estado not in ESTADOS_INVALIDOS:
		movimiento = Input.get_axis('ui_left', 'ui_right')
		
		if not _cooldown_salto and Input.is_action_just_pressed('ui_up') and estado != estados.caer:
			estado = estados.saltar

	moverse(movimiento, delta)
	caer(delta, suelo)
	
	if not suelo:
		velocity.y += get_gravity().y * delta
	
	move_and_slide()

# 7. Setters y Getters
func set_coordenada(nueva_coordenada: Vector2i) -> void:
	if nueva_coordenada == coordenada: return
	coordenada_anterior = coordenada
	coordenada = nueva_coordenada
	cambio_de_coordenada.emit(coordenada, coordenada_anterior)

func set_estado(nuevo_estado: estados) -> void:
	if nuevo_estado == estado: return
	
	var aux: estados = estado
	estado = nuevo_estado
	
	print('el nuevo estado es %s' % estados.keys()[estado])
	
	match estado:
		estados.hielo:
			hielo = 4.0
			sonidos.hielo()
			_estado_anterior = aux
		
		estados.saltar:
			var adicional = -100.0 if furia else 0.0
			velocity.y = -300.0 + adicional
			
			_cooldown_salto = true
			tiempo_coyote = 1.0
			await get_tree().create_timer(0.2).timeout
			_cooldown_salto = false
		
		estados.muerto:
			rotation_degrees -= 90.0
			modulate = Color.BLACK
			morir.emit()

func set_furia(nueva_furia: float) -> void:
	if furia == nueva_furia: return
	
	furia = nueva_furia
	contadores.contadores['furia'] = furia
	sprite.modulate.g = 0.5 if furia else 1.0
	_multiplicador = 2.0 if furia else 1.0

# 8. Métodos propios del personaje
func moverse(movimiento: float, delta: float) -> void:
	var freno: float = 3.0
	
	sprite.skew = deg_to_rad(30.0) * movimiento * (_multiplicador)
	
	if movimiento:
		if estado in ESTADOS_PERMITIDOS:
			estado = estados.caminar
		sprite.flip_h = movimiento < 0
		freno = 1.5
	elif estado == estados.caminar:
		estado = estados.quieto
	
	velocity.x = lerp(velocity.x, 300.0 * movimiento * _multiplicador, freno * delta)

func caer(delta: float, suelo: bool) -> void:
	if suelo:
		tiempo_coyote = 0.0
		if estado == estados.caer:
			estado = estados.quieto
	elif tiempo_coyote < 1.0:
		tiempo_coyote += delta
	elif estado != estados.caer:
		estado = estados.caer
	
	if estado == estados.saltar and velocity.y >= 0:
		estado = estados.caer

func tirar_estrella() -> void:
	estrellas += 1
	
	var star: RigidBody2D = global.ESTRELLA.instantiate()
	star.global_position = global_position
	
	var angulo: float = get_angle_to(get_global_mouse_position())
	star.linear_velocity = 900.0 * Vector2.from_angle(angulo) * _multiplicador
	
	star.rotation_degrees = randf_range(0, 360)
	
	get_tree().root.add_child.call_deferred(star)


const _PLACEHOLDER: Texture2D = preload('res://texturas/objetos/holder.png')

@onready var el_inventario: HBoxContainer = $gui/inventario

@onready var c_textura: VBoxContainer = $gui/inventario/contenedortextura/textura
@onready var c_texto: VBoxContainer = $gui/inventario/contenedortextura/contenedortexto

var mostrar: bool = false: 
	set(mostrar_nuevo):
		
		if mostrar == mostrar_nuevo: return
		mostrar = mostrar_nuevo
		
		if mostrar:
			
			var valores = lista_de_objetos.values()
			var claves = lista_de_objetos.keys()
			var tamaño = valores.size()
			
			for i in range(3):
				c_textura.get_child(i).texture = valores[_indice + i] if tamaño > _indice + i else _PLACEHOLDER
				c_texto.get_child(i).get_child(0).text = claves[_indice + i] if tamaño > _indice + i else '?'
		
		el_inventario.visible = mostrar


var _indice: int = 0

func _estrella(estrella: Node2D) -> void:
	estrella.queue_free()
	
	salud -= 1

var lista_de_objetos: Dictionary = {}

func _recoger_objeto(objeto: Objeto) -> void:
	
	lista_de_objetos[objeto.name] = objeto.sprite.texture
	
	objeto.queue_free()
