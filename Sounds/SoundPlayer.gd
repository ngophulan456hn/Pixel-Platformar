extends Node

onready var audioPlayers := $AudioPlayers

const HURT = preload("res://Sounds/Sounds_Hurt.wav")
const JUMP = preload("res://Sounds/Sounds_Jump.wav")

func _ready():
	pass 

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
