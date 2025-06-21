class_name Enemy_state_Chase extends Enemy_state

@export var anim_name: String = "run"
@export var chase_speed: float = 17.0

@export_category("AI")
@export var after_chase_state: Enemy_state

@export_category("Sounds") ## Load expected sounds in inspector
@export var sound_mp3 : Resource
@export var sound1_mp3 : Resource
@export var sound2_mp3 : Resource
@export var sound_wav : Resource
@export var sound1_wav : Resource
@export var sound2_wav : Resource

@onready var chase: Chase_Action = $"../../Ai_action/chase"
@onready var line_of_sight: RayCast3D = $"../../line_of_sight"
@onready var stun: Enemy_state_Stun = $"../stun"
@onready var audio_stream_player: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"


var _player: Player = null

func init() -> void:
	chase.chase_target_found.connect(start_chase)
	chase.body_exited.connect(_on_body_exited)
	stun.after_stun.connect(start_chase)
	stun.player_visible_on_ray.connect(_on_ray_detected)
	line_of_sight.seen_player.connect(_on_player_spotted)
	# Don't connect stun/death signals here - let them handle globally

func enter() -> void:
	enemy.velocity = Vector3.ZERO
	enemy.update_animation(anim_name)
	
	audio_stream_player.stream = sound_mp3
	audio_stream_player.pitch_scale = 1.22
	audio_stream_player.unit_size = 20
	audio_stream_player.volume_db = -18
	audio_stream_player.play()
	
	audio_stream_player.finished.connect(next_audio)
	
	

func exit() -> void:
	_player = null
	enemy.velocity = Vector3.ZERO
	enemy.update_animation("idle")
	audio_stream_player.stop()
	audio_stream_player.finished.disconnect(next_audio)

# Modified process function to check for death first
func process(_delta: float) -> Enemy_state:
	# First check if we should die (highest priority)
	if enemy.hp <= 0:
		return state_machine.get_node("death") as Enemy_state_Death
	
	# Then check if player left
	if _player == null:
		return after_chase_state
	
	return null

# Physics handles movement only if we're still alive and chasing
func physics(_delta: float) -> Enemy_state:
	if _player and enemy.hp > 0:  # Only chase if alive
		
		var player_position = _player.global_position
		var target_position =  enemy.global_position.direction_to(player_position)
		
		if enemy.position.distance_to(player_position) > 3:
			enemy.velocity = target_position * 1.5
			enemy.set_direction(target_position)
			#enemy.look_at(player_position)
			enemy.move_and_slide()
		
		#var direction = enemy.global_position.direction_to(_player.global_position)
		#enemy.velocity = direction * chase_speed
		#enemy.set_direction(direction)
		#enemy.move_and_slide()
	return null

func start_chase(player: Player) -> void:
	_player = player
	# Only update state and animation if we're not already in a higher priority state
	if not (state_machine.current_state is Enemy_state_Death or 
			state_machine.current_state is Enemy_state_Stun):
		state_machine.ChangeState(self)
		enemy.update_animation(anim_name)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		_player = null
		
# New handler for raycast detection
func _on_player_spotted(player: Player) -> void:
	if not _is_higher_priority_state_active():
		start_chase(player)

func _is_higher_priority_state_active() -> bool:
	return (state_machine.current_state is Enemy_state_Death or 
			state_machine.current_state is Enemy_state_Stun)

func _on_ray_detected(player: Player):
	if not _is_higher_priority_state_active():
		start_chase(player)

func next_audio () -> void:
	audio_stream_player.stream = sound1_mp3
	audio_stream_player.pitch_scale = 1.22
	audio_stream_player.volume_db = -18
	audio_stream_player.unit_size = 20
	audio_stream_player.play()
