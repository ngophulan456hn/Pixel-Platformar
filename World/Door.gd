extends Area2D

export(String, FILE, "*.tscn") var target_level_path = ""

var player = null

func _ready():
	pass

func _process(delta):
	if player and player.is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			if not target_level_path.empty():
				go_to_next_room()
			
func _on_Door_body_entered(body):
	if body is Player:
		player = body
			
func _on_Door_body_exited(body):
	if body is Player:
		player = null
		
func go_to_next_room():
	Transitions.play_exit_transition()
	get_tree().paused = true
	yield(Transitions, "transition_completed")
	Transitions.play_enter_transition()
	get_tree().paused = false
	get_tree().change_scene(target_level_path)
