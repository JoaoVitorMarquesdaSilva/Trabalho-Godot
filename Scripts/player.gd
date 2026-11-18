extends CharacterBody2D

signal vida_mudou(hp)
signal morreu

@export var limites := Rect2(16, 16, 1120, 616)
@export var velocidade := 200.0
var hp := 3
var invulneravel := false

@onready var anim: AnimatedSprite2D = $Anim

func _ready():
	add_to_group("player")
	anim.play("baixo")

func _physics_process(_delta):
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * velocidade
	move_and_slide()
	global_position = global_position.clamp(limites.position, limites.end)
	_atualizar_animacao(dir)

func _atualizar_animacao(dir: Vector2):
	if dir == Vector2.ZERO:
		return  # parado: mantém a última direção
	if abs(dir.x) > abs(dir.y):
		anim.play("direita" if dir.x > 0 else "esquerda")
	else:
		anim.play("baixo" if dir.y > 0 else "cima")

func levar_dano(qtd := 1):
	if invulneravel:
		return
	hp -= qtd
	vida_mudou.emit(hp)
	if hp <= 0:
		morreu.emit()
		return
	invulneravel = true
	modulate = Color(1, 0.4, 0.4)
	await get_tree().create_timer(1.0).timeout
	invulneravel = false
	modulate = Color.WHITE
