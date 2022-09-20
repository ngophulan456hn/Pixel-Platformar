extends Area2D

onready var animatedSprite := $AnimatedSprite

func _ready():
	pass 

func _on_Checkpoint_body_entered(body):
	if not body is Player:
		return
	animatedSprite.play("Checked")
	Events.emit_signal("hit_checkpoint", position)
