class_name Enemy_state_Idle extends Enemy_state

@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : Enemy_state

@onready var audio_stream_player: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"

@export_category("Sounds") ## Load expected sounds in inspector
@export var sound_mp3 : Resource
@export var sound1_mp3 : Resource
@export var sound2_mp3 : Resource
@export var sound_wav : Resource
@export var sound1_wav : Resource
@export var sound2_wav : Resource

var _timer : float = 0.0

func init() -> void:
	pass




func enter() -> void:
	enemy.velocity = Vector3.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(anim_name)
	audio_stream_player.stream = sound_mp3
	audio_stream_player.pitch_scale = 1
	audio_stream_player.volume_db = 0
	audio_stream_player.unit_size = 20
	audio_stream_player.play()
	
	pass




# when player exist a state
func exit() -> void:
	
	audio_stream_player.stop()
	pass
	
	

func process(_delta : float) -> Enemy_state:
	_timer -= _delta
	if _timer < 0:
		return after_idle_state
	return null
	
	
	
	
	
func physics (_delta : float) -> Enemy_state:
	return null
