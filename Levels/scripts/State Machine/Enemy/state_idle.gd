class_name Enemy_state_Idle extends Enemy_state

@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : Enemy_state

var _timer : float = 0.0

func init() -> void:
	pass




func enter() -> void:
	enemy.velocity = Vector3.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(anim_name)
	pass




# when player exist a state
func exit() -> void:
	pass
	
	

func process(_delta : float) -> Enemy_state:
	_timer -= _delta
	if _timer < 0:
		return after_idle_state
	return null
	
	
	
	
	
func physics (_delta : float) -> Enemy_state:
	return null
