class_name state_jump extends State

@export var SPEED : float = 7.0
const JUMP_VELOCITY : float = 10.5


#@onready var running: State = $"../running"
@onready var idle: State = $"../idle"
@onready var walk: State = $"../walk"
@onready var shoot: State = $"../shoot"
@onready var gun_animation: AnimationPlayer = $"../../camera/rifile/AnimationPlayer"





# when the player enters this state
func Enter() -> void:
	player.velocity.y = JUMP_VELOCITY 
	#player.update_animation("walking")
	pass


# when player exist a state
func Exit() -> void:
	pass
	

func Process(_delta : float) -> State:
	if player.direction == Vector3.ZERO:
		return idle
	if player.direction != Vector3.ZERO:
		return walk
	

	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * _delta
		
#
	# Maintain horizontal movement
	player.velocity.x = player.direction.x * SPEED
	player.velocity.z = player.direction.z * SPEED
	
	
		
	
	return null
	
	
func Physics (_delta : float) -> State:
	return null
	

func HandleInput (_event : InputEvent) -> State:
	return null
