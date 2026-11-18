extends CharacterBody2D

enum Estado { PATRULHA, PERSEGUE, INCHADO }
var estado := Estado.PATRULHA

@export var vel_patrulha := 60.0
@export var vel_perseguicao := 110.0
@export var alcance_deteccao := 220.0
@export var alcance_inchar := 70.0
@export var limites := Rect2(80, 80, 992, 488)
@export var alcance_dano := 55.0

var player: Node2D
var alvo := Vector2.ZERO

@onready var hitbox: Area2D = $Hitbox
@onready var anim: AnimatedSprite2D = $Anim

func _ready():
	player = get_tree().get_first_node_in_group("player")
	anim.play("normal")
	_novo_alvo()

func _physics_process(_delta):
	var dist := global_position.distance_to(player.global_position)
	match estado:
		Estado.PATRULHA:
			_ir_para(alvo, vel_patrulha)
			if global_position.distance_to(alvo) < 10:
				_novo_alvo()
			if dist < alcance_deteccao:
				_mudar(Estado.PERSEGUE)
		Estado.PERSEGUE:
			_ir_para(player.global_position, vel_perseguicao)
			if dist < alcance_inchar:
				_mudar(Estado.INCHADO)
			elif dist > alcance_deteccao * 1.3:
				_mudar(Estado.PATRULHA)
		Estado.INCHADO:
			velocity = Vector2.ZERO
			if dist < alcance_dano:
				player.levar_dano(1)
			if dist > alcance_inchar * 1.8:
				_mudar(Estado.PERSEGUE)
	move_and_slide()

func _mudar(novo: Estado):
	estado = novo
	anim.play("inchado" if novo == Estado.INCHADO else "normal")

func _ir_para(pos: Vector2, vel: float):
	velocity = (pos - global_position).normalized() * vel

func _novo_alvo():
	alvo = Vector2(
		randf_range(limites.position.x, limites.end.x),
		randf_range(limites.position.y, limites.end.y))
