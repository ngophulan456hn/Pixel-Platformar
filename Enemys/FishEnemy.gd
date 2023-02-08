extends Node2D

enum {HOVER, FALL, RISE, LAND}

var state = HOVER

onready var start_position = global_position
onready var timer := $Timer
onready var animatedSprite := $AnimatedSprite
onready var playerCheck = $PlayerCheck

export(bool) var check_player = false

const FALL_SPEED = 100
const RISE_SPEED = 200
const HIGH_LIMIT = 150

func _ready():
	animatedSprite.play("Moving")
	pass

func _physics_process(delta):
	match state:
		HOVER:
			hover_state()
		FALL:
			fall_state(delta)
		RISE:
			rise_state(delta)
		LAND:
			land_state()
			
func hover_state():
	if timer.time_left == 0:
		if check_player:
			if playerCheck.is_colliding() and playerCheck.get_collider() is Player:
				state = RISE
		else:
			state = RISE
	
func rise_state(delta):
	position.y = move_toward(position.y, start_position.y - HIGH_LIMIT, delta * RISE_SPEED)
	if position.y == start_position.y - HIGH_LIMIT:
		position.y -= FALL_SPEED * delta
		state = LAND
		timer.start(0.5)

func land_state():
	if timer.time_left == 0:
		state = FALL
	
func fall_state(delta):
	position.y = move_toward(position.y, start_position.y, delta * FALL_SPEED)
	if position.y == start_position.y:
		timer.start(1)
		state = HOVER
