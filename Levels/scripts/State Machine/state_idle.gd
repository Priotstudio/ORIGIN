class_name state_idle extends State

var SPEED : float = 3.0

#@onready var running: State = $"../running"
#@onready var kicking: State = $"../kicking"
@onready var walk: State = $"../walk"
@onready var jump: State = $"../jump"
@onready var shoot: State = $"../shoot"
@onready var jump_and_shoot: state_jump_and_shoot = $"../jump and shoot"

@onready var gun_animation: AnimationPlayer = $"../../camera/rifile/AnimationPlayer"
@onready var marin_animation: AnimationPlayer = $"../../camera/Marin/AnimationPlayer"







# when the player enters this state
func Enter() -> void:
	#gun_animation.play('idle')
	#marin_animation.play("idle")
	#player.update_animation("idle")
	#player.locked = false
	pass


# when player exist a state
func Exit() -> void:
	#gun_animation.stop()
	pass
	

func Process(_delta : float) -> State:
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * _delta
		return jump_and_shoot

		
	if player.direction != Vector3.ZERO:
		return walk
	
	player.velocity = Vector3.ZERO
	
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		return jump
		
	if Input.is_action_pressed("shoot"):
		if !gun_animation.is_playing():
			return shoot
	
	return null
	
	
func Physics (_delta : float) -> State:
	return null
	
	

func HandleInput (_event : InputEvent) -> State:
	
			#return shoot
	
		##return kicking
	return null
