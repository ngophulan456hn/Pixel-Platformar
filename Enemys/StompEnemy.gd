extends Node2D

enum {HOVER, FALL, RISE, LAND}

var state = HOVER

onready var start_position = global_position
onready var timer := $Timer
onready var rayCast2D := $RayCast2D
onready var animatedSprite := $AnimatedSprite
onready var particles2D := $Particles2D
onready var playerCheck = $PlayerCheck

export(bool) var check_player = false

const FALL_SPEED = 100
const RISE_SPEED = 50

func _ready():
	particles2D.one_shot = true 

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
	if check_player:
		if playerCheck.is_colliding() and playerCheck.get_collider() is Player:
			state = FALL
	else:
		state = FALL
	
func fall_state(delta):
	animatedSprite.play("Falling")
	position.y += FALL_SPEED * delta
	if rayCast2D.is_colliding():
		var collision_point = rayCast2D.get_collision_point()
		position.y = collision_point.y
		state = LAND
		timer.start(1.0)
		particles2D.emitting = true

func land_state():
	if timer.time_left == 0:
		state = RISE
	
func rise_state(delta):
	animatedSprite.play("Rising")
	position.y = move_toward(position.y, start_position.y, delta * RISE_SPEED)
	if position.y == start_position.y:
		state = HOVER
