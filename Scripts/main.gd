extends Node2D

const ITEM := preload("res://Jogo/item.tscn")
const ARENA := Rect2(80, 80, 992, 488)
const META := 20
const MAX_NA_TELA := 5

var coletados := 0
var fim := false

@onready var player = $Player
@onready var pontos: Label = $HUD/Pontos
@onready var vida: Label = $HUD/Vida
@onready var msg: Label = $HUD/Mensagem

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.vida_mudou.connect(_on_vida)
	player.morreu.connect(_terminar.bind(false))
	$SpawnTimer.timeout.connect(_spawnar)
	_on_vida(player.hp)
	_atualizar_pontos()

func _spawnar():
	if get_tree().get_nodes_in_group("itens").size() >= MAX_NA_TELA:
		return
	var item = ITEM.instantiate()
	item.position = Vector2(
		randf_range(ARENA.position.x, ARENA.end.x),
		randf_range(ARENA.position.y, ARENA.end.y))
	item.coletado.connect(_on_coletado)
	add_child(item)

func _on_coletado():
	coletados += 1
	_atualizar_pontos()
	if coletados >= META:
		_terminar(true)

func _on_vida(hp):
	vida.text = "Vida: %d" % hp

func _atualizar_pontos():
	pontos.text = "Itens: %d / %d" % [coletados, META]

func _terminar(venceu: bool):
	if fim:
		return
	fim = true
	msg.text = ("VITÓRIA!" if venceu else "DERROTA") + "\nEnter para reiniciar"
	get_tree().paused = true

func _unhandled_input(event):
	if fim and event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()
