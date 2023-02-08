extends Area2D

onready var sprite := $Sprite

export(Resource) var moveData = preload("res://Player/DefaultPlayerMovementData.tres")

func _ready():
	pass 

func _on_IncreaseJumpItem_body_entered(body):
	if not body is Player:
		return
	moveData.DOUBLE_JUMP_COUNT += 1
	queue_free()
