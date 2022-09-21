extends Node2D

const PlayerScene = preload("res://Player/Player.tscn")

onready var switch := $Switch
onready var bridge := $Bridges

var player_spawn_location = Vector2.ZERO

func _ready():
	bridge.visible = false
	
func _process(delta):
	if switch.active:
		bridge.visible = true
