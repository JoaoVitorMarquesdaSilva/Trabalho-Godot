extends Area2D

signal coletado

@export var raio_coleta := 24.0
var player: Node2D

func _ready():
	add_to_group("itens")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if player and global_position.distance_to(player.global_position) < raio_coleta:
		coletado.emit()
		queue_free()
