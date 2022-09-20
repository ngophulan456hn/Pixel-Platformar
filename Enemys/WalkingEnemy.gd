extends KinematicBody2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var ledgeCheckRight = $LedgeCheckRight
onready var ledgeCheckLeft = $LedgeCheckLeft
onready var playerCheck = $PlayerCheck
onready var animatedSprite = $AnimatedSprite
onready var timer = $Timer

const WALKING_SPEED = 25

enum { MOVING, HIDE, HIDING}

var state = MOVING

func _ready():
	pass 

func _physics_process(delta):
	match state:
		MOVING:
			move_state()
		HIDE:
			hide_state()
		HIDING:
			hiding_state()
			
func move_state():
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheckRight.is_colliding() or not ledgeCheckLeft.is_colliding()
	animatedSprite.animation = "Walking"
	
	if found_wall or found_ledge:
		direction *= -1
	
	animatedSprite.flip_h = direction.x > 0
	
	velocity = direction * WALKING_SPEED
	move_and_slide(velocity, Vector2.UP)
	
	if playerCheck.is_colliding() and playerCheck.get_collider() is Player:
		state = HIDE
		
func hide_state():
	animatedSprite.animation = "Hide"
	velocity.x = move_toward(velocity.x, 0, 100)
	if not playerCheck.is_colliding():
		state = HIDING
		timer.start(1.0)
		
func hiding_state():
	if timer.time_left == 0:
		state = MOVING
		
