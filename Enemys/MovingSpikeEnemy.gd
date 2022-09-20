tool
extends Path2D

export(String, "Loop", "Bounce") var path = "Loop" setget set_animation_type
export(int) var speed = 1 setget set_speed

onready var animationPlayer := $AnimationPlayer

func _ready():
	play_update_animation(animationPlayer)
			
func play_update_animation(ap):
	match path:
		"Loop":
			ap.play("MoveAlongPathLoop")
		"Bounce":
			ap.play("MoveAlongPathBounce")
			
func set_animation_type(value):
	path = value
	var ap = find_node("AnimationPlayer")
	if ap:
		play_update_animation(ap)
		
func set_speed(value):
	speed = value
	var ap = find_node("AnimationPlayer")
	if ap:
		ap.playback_speed = speed
