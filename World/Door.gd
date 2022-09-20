extends Area2D

export(String, FILE, "*.tscn") var target_level_path = ""

var over_player = false

func _ready():
	pass
	
func _on_Door_body_entered(body):
	if body is Player:
		if not target_level_path.empty():
			Transitions.play_exit_transition()
			get_tree().paused = true
			yield(Transitions, "transition_completed")
			Transitions.play_enter_transition()
			get_tree().paused = false
			get_tree().change_scene(target_level_path)
			
