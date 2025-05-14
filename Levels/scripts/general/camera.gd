extends Camera3D

class_name FPSCameraShake

## Camera Shake Parameters
@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var shake_decay: float = 3.0          # How quickly shaking stops
@export var max_shake_offset: Vector3 = Vector3(0.15, 0.15, 0.0)  # Max position offset
@export var max_shake_rotation: Vector3 = Vector3(0.1, 0.1, 0.05) # Max rotation in radians

## Advanced Settings
@export var noise_speed: float = 30.0         # How fast the noise samples change
@export var trauma_exponent: float = 2.0      # Trauma power (makes shakes feel more intense)
@export var recovery_smoothness: float = 5.0  # How smoothly the camera returns

var trauma: float = 0.0                       # Current shake intensity (0-1)
var time: float = 0.0
var original_position: Vector3
var original_rotation: Vector3

func _ready():
	original_position = position
	original_rotation = rotation
	
	# Configure noise for smooth randomness
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.5
	noise.fractal_octaves = 2

func _process(delta):
	time += delta
	
	if trauma > 0:
		# Apply shake with noise-based smooth randomness
		var shake = pow(trauma, trauma_exponent)
		
		# Position shake
		position = original_position + Vector3(
			max_shake_offset.x * shake * noise.get_noise_1d(time * noise_speed),
			max_shake_offset.y * shake * noise.get_noise_1d(time * noise_speed + 100),
			max_shake_offset.z * shake * noise.get_noise_1d(time * noise_speed + 200)
		)
		
		# Rotation shake (convert to quaternion for smooth interpolation)
		var rot_offset = Vector3(
			max_shake_rotation.x * shake * noise.get_noise_1d(time * noise_speed + 300),
			max_shake_rotation.y * shake * noise.get_noise_1d(time * noise_speed + 400),
			max_shake_rotation.z * shake * noise.get_noise_1d(time * noise_speed + 500)
		)
		
		rotation = original_rotation + rot_offset
		
		# Decay trauma smoothly
		trauma = max(trauma - shake_decay * delta, 0.0)
	else:
		# Smoothly return to original position
		position = position.lerp(original_position, recovery_smoothness * delta)
		rotation = rotation.lerp(original_rotation, recovery_smoothness * delta)

## Public Methods

# Add trauma (shake intensity) to the camera
func add_trauma(amount: float):
	trauma = clamp(trauma + amount, 0.0, 1.0)

# Set trauma directly
func set_trauma(amount: float):
	trauma = clamp(amount, 0.0, 1.0)

# Call this when shooting
func apply_gun_shake():
	add_trauma(0.25)  # Moderate shake for gunfire
