extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var animateSprite = $AnimatedSprite
onready var softCollisions = $SoftCollisions

enum { IDLE, CHASE}

var state = IDLE
var first_position = Vector2.ZERO
var velocity = Vector2.ZERO

const MAX_SPEED = 50
const ACCELERATION = 500
const FRICTION = 500

func _ready():
	animateSprite.frame = rand_range(0, 2)
	animateSprite.play("Flying")
	animateSprite.playing = true
	
func _physics_process(delta):
	match state:
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_toward_point(player.global_position,delta)
			else: 
				state = IDLE
				
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)

func accelerate_toward_point(position: Vector2, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	animateSprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
