class_name state_walk extends State

@export var SPEED : float = 20.0
const JUMP_VELOCITY : float = 4.5

const BOB_FRQ = 2.0
const BOb_AMP = 0.08
var t_bob = 0.0

#@onready var running: State = $"../running"
@onready var idle: State = $"../idle"
@onready var jump: State = $"../jump"
@onready var shoot: State = $"../shoot"
@onready var jump_and_shoot: state_jump_and_shoot = $"../jump and shoot"
@onready var rifile: Node3D = $"../../camera/rifile"
@onready var camera: FPSCameraShake = $"../../camera/Marin/Camera3D"



@onready var gun_animation: AnimationPlayer = $"../../camera/rifile/AnimationPlayer"



# when the player enters this state
func Enter() -> void:
	#player.update_animation("walking")
	
	
	pass


# when player exist a state
func Exit() -> void:
	pass
	

func Process(_delta : float) -> State:
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * _delta
		return jump_and_shoot

	if player.direction == Vector3.ZERO:
		return idle
		
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		return jump
		
	if Input.is_action_pressed("shoot"):
		if !gun_animation.is_playing():
			return shoot
	
	
	player.velocity.x = player.direction.x * SPEED
	player.velocity.z = player.direction.z * SPEED
	
	t_bob += _delta * player.velocity.length() * float(player.is_on_floor())
	#camera.transform.origin = player._headbob (t_bob)
	
	
	
	return null
	
	
func Physics (_delta : float) -> State:
	return null
	

func HandleInput (_event : InputEvent) -> State:
	return null
