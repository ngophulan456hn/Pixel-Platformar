extends KinematicBody2D

class_name Player

enum { MOVE, CLIMB }

onready var animatedSprite := $AnimatedSprite
onready var ladderCheck := $LadderCheck
onready var jumpBufferTimer := $JumpBufferTimer
onready var coyoteJumpTimer := $CoyoteJumpTimer
onready var remoteTransform2D := $RemoteTransform2D

export(Resource) var moveData = preload("res://Player/DefaultPlayerMovementData.tres")

var velocity = Vector2.ZERO
var skinPlayer = 'Green'
var modeGame = 'Default'
var state = MOVE
var double_jump = moveData.DOUBLE_JUMP_COUNT
var buffered_jump = false
var coyote_jump = false

func _ready():
	match skinPlayer:
		'Green':
			animatedSprite.frames = load("res://Player/PlayerGreenSkin.tres")
		'Blue':
			animatedSprite.frames = load("res://Player/PlayerBlueSkin.tres")
		'Orange':
			animatedSprite.frames = load("res://Player/PlayerOrangeSkin.tres")
		'Pink':
			animatedSprite.frames = load("res://Player/PlayerPinkSkin.tres")
		'Yellow':
			animatedSprite.frames = load("res://Player/PlayerYellowSkin.tres")
		
func  _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right") #Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE:
			move_state(input, delta)
		CLIMB:
			climb_state(input, delta)
			
	if not is_on_floor():
		fall_to_dead()
		
func move_state(input: Vector2, delta):
	if is_on_ladder() and Input.is_action_just_pressed("ui_up"):
		state = CLIMB
		
	apply_gravity(delta)
	if not horizontal_move(input):
		apply_fricion(delta)
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x, delta)
		animatedSprite.animation = "Run"
		
		animatedSprite.flip_h = input.x > 0
		
	if is_on_floor():
		reset_double_jump()
	else:
		animatedSprite.animation = "Jump"
		
	if can_jump():
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		fast_fall(delta)
	
	var was_is_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP) #set velocity equal here to reset gravity fall
	var just_land = is_on_floor() and was_is_air
	if just_land:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
		
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()
	
func climb_state(input: Vector2, delta):
	if not is_on_ladder():
		state = MOVE
		
	if input.length() != 0:
		animatedSprite.animation = "Run"
	else:
		animatedSprite.animation = "Idle"
		
	velocity = input * moveData.MAX_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
	
func input_jump():
	if Input.is_action_just_pressed("ui_up") or buffered_jump:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = -moveData.HIGHT_JUMP
		buffered_jump = false

func input_jump_release():
	if Input.is_action_just_released("ui_up") and velocity.y < -moveData.MIN_HIGHT_JUMP:
		velocity.y = -moveData.MIN_HIGHT_JUMP
		
func input_double_jump():
	if Input.is_action_just_pressed("ui_up") and double_jump > 0:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = -moveData.HIGHT_JUMP
		double_jump -= 1
	
func buffer_jump():
	if Input.is_action_just_pressed("ui_up"):
		buffered_jump = true
		jumpBufferTimer.start()
	
func fast_fall(delta):
	if velocity.y > 0:
		apply_gravity(delta)
		
func horizontal_move(input: Vector2):
	return input.x != 0
		
func reset_double_jump():
	double_jump = moveData.DOUBLE_JUMP_COUNT
	
func can_jump():
	return is_on_floor() or coyote_jump

func apply_gravity(delta):
	velocity.y += moveData.GRAVITY * delta
	velocity.y = min(velocity.y, moveData.MAX_SPEED_FALL)
	
func apply_fricion(delta):
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION * delta)

func apply_acceleration(amount, delta):
	velocity.x = move_toward(velocity.x, amount * moveData.MAX_SPEED, moveData.ACCELERATION * delta)
	
func power_up(): #Create power up item
	moveData = load("res://FastPlayerMovementData.tres")
	
func is_on_ladder():
	if not ladderCheck.is_colliding():
		return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder:
		return false
	return true
	
func player_die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	Events.emit_signal("player_died")
	queue_free()
	
func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path
	
func fall_to_dead():
	if velocity.y > 800:
		player_die()

func _on_JumpBufferTimer_timeout():
	buffered_jump = false

func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false
	

