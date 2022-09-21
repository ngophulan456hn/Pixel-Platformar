extends Area2D

onready var animatedSprite := $AnimatedSprite

var active = false
var player = null

func _ready():
	animatedSprite.play("Idle")
	
func _process(delta):
	if player and player.is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			animatedSprite.play("Switching")
			active = true
		
func _on_Switch_body_entered(body):
	if body is Player:
		player = body

func _on_Switch_body_exited(body):
	if body is Player:
		player = null
