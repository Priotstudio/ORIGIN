extends State
class_name state_jump_and_shoot

var fire_delay := 0.1  # Time between shots in seconds
var time_since_last_shot := 0.0

var SPEED : float = 3.0
var bullet = load("res://Levels/scenes/bullet.tscn")
var instance

#@onready var running: State = $"../running"
#@onready var kicking: State = $"../kicking"
@onready var walk: State = $"../walk"
@onready var jump: State = $"../jump"
@onready var shoot: State = $"../shoot"
@onready var idle: State = $"../idle"
@onready var ray_cast_gun: RayCast3D = $"../../camera/rifile/RayCast3D"
@onready var gun_animation: AnimationPlayer = $"../../camera/rifile/AnimationPlayer"
@onready var camera: FPSCameraShake = $"../../camera/Marin/Camera3D"

# Preload shot sound
var shot_sound = preload("res://Assets/Audio/shot.mp3")

# when the player enters this state
func Enter() -> void:
	# You don't need to do anything here
	pass

# when player exits a state
func Exit() -> void:
	pass

func Process(_delta : float) -> State:
	time_since_last_shot += _delta

	if not player.is_on_floor():
		if Input.is_action_pressed("shoot") and time_since_last_shot >= fire_delay:
			time_since_last_shot = 0.0  # Reset the timer
			gun_animation.play("shoot")
			camera.apply_gun_shake()

			# Create a new AudioStreamPlayer3D for each shot
			var gunshot_player = AudioStreamPlayer3D.new()
			gunshot_player.stream = shot_sound

			# Position the sound at the gun's global position
			gunshot_player.global_transform = ray_cast_gun.global_transform  # Position it at the gun's location

			# Add it to the current scene
			get_tree().current_scene.add_child(gunshot_player)
			gunshot_player.play()  # Play the shot sound

			# Clean up the shot audio after it finishes playing
			gunshot_player.connect("finished", Callable(gunshot_player, "queue_free"))

			# Instantiate the bullet
			instance = bullet.instantiate()
			instance.position = ray_cast_gun.global_position

			# Add randomness to the bullet trajectory
			var random_spread : float = 0.2  # Adjust this value to control the spread
			var random_z = randf() * random_spread - (random_spread / 2)

			# Apply the randomness to the basis (direction of the bullet)
			instance.transform.basis = ray_cast_gun.global_transform.basis
			instance.transform.basis.z += Vector3(0, 0, random_z)

			get_parent().add_child(instance)

		player.velocity += player.get_gravity() * _delta
		return 

	if player.direction != Vector3.ZERO:
		return walk
	if player.direction == Vector3.ZERO:
		return idle
	
	player.velocity = Vector3.ZERO
	
	return null

func Physics (_delta : float) -> State:
	return null

func HandleInput (_event : InputEvent) -> State:
	return null
