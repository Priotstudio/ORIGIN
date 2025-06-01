class_name Enemy_state_Stun extends Enemy_state

@export var anim_name : String = "stun"
#@export var knock_back_speed : float = 200.0
#@export var decelarate_speed : float = 10.0

@export_category("AI")
@export var next_state : Enemy_state

@export_category("Sounds") ## Load expected sounds in inspector
@export var sound_mp3 : Resource
@export var sound1_mp3 : Resource
@export var sound2_mp3 : Resource
@export var sound_wav : Resource
@export var sound1_wav : Resource
@export var sound2_wav : Resource

@onready var chase: Chase_Action = $"../../Ai_action/chase"
@onready var Chase: Enemy_state_Chase = $"../chase"
@onready var line_of_sight: RayCast3D = $"../../line_of_sight"
@onready var audio_stream_player: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"


signal after_stun (player : Player)
signal player_visible_on_ray(player: Player)



var _damage_position : Vector3

var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damage)

	pass




func enter() -> void:
	#enemy.invalnurable = true
	#_direction = enemy.global_position.direction_to(_damage_position)
	_animation_finished = false
	#enemy.set_direction(_direction)
	#enemy.velocity = _direction * -knock_back_speed
	
	audio_stream_player.stream = sound_mp3
	audio_stream_player.volume_db = 0
	audio_stream_player.pitch_scale = 1
	audio_stream_player.play()
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	
	pass




# when player exist a state
func exit() -> void:
	#enemy.invalnurable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	audio_stream_player.stop()
	pass
	
	

func process(_delta : float) -> Enemy_state:
	if _animation_finished == true:
		return next_state
	
	for body in chase.get_overlapping_bodies():
		if body is Player:
			after_stun.emit(body)
			
	if line_of_sight.is_colliding() and line_of_sight.get_collider() is Player:
		player_visible_on_ray.emit(line_of_sight.get_collider())
		
	#enemy.velocity -= enemy.velocity * decelarate_speed * _delta
	return null
	
	
	
	
	
func physics (_delta : float) -> Enemy_state:
	return null



func _on_enemy_damage(hurt_box: Hurt_box) -> void:
	_damage_position = hurt_box.global_position
	# Force the state change immediately
	state_machine.ChangeState(self)
	
	
func _on_animation_finished (_a : String) -> void:
	_animation_finished = true
	
