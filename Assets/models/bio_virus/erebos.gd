class_name Enemy extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: EnemyStateMachine = $Enemy_state_machine
@onready var hit_box: Hit_box = $HitBox

@export var hp: int = 100

signal enemy_damaged(hurt_box : Hurt_box)
signal enemy_destroyed(hurt_box : Hurt_box)


# 3D cardinal directions (forward, right, back, left in XZ plane)
const DIR_4: Array[Vector3] = [
	Vector3.FORWARD,  # (0, 0, -1)
	Vector3.RIGHT,    # (1, 0, 0)
	Vector3.BACK,     # (0, 0, 1)
	Vector3.LEFT      # (-1, 0, 0)
]

var direction: Vector3 = Vector3.ZERO
var cardinal_direction: Vector3 = Vector3.FORWARD
var invulnerability: bool = false
var player = null  # Initialize as null, set in _ready

signal direction_changed(new_direction: Vector3)

func _ready() -> void:
	state_machine.initialize(self)
	player = GlobalPlayerManager.player
	if not player:
		push_warning("Player not found in GlobalPlayerManager!")
	hit_box.Damaged.connect(TakeDamage)

func _physics_process(delta: float) -> void:
	# Apply velocity and move with collision detection
	move_and_slide()

func set_direction(new_direction: Vector3, lerp_factor: float = 1.0) -> bool:
	# Normalize and remove Y component for XZ-plane movement
	direction = new_direction.normalized()
	direction.y = 0  # Keep movement in XZ plane
	if direction == Vector3.ZERO:
		return false

	# Find closest cardinal direction
	var closest_dir: Vector3 = DIR_4[0]
	var max_dot: float = closest_dir.dot(direction)
	for dir in DIR_4:
		var dot = dir.dot(direction)
		if dot > max_dot:
			max_dot = dot
			closest_dir = dir

	# Only update if direction changes
	if closest_dir == cardinal_direction and lerp_factor >= 1.0:
		return false

	cardinal_direction = closest_dir
	direction_changed.emit(cardinal_direction)
	
	# Calculate target rotation
	var target_rotation = atan2(cardinal_direction.x, cardinal_direction.z)
	
	# Smoothly interpolate rotation
	if lerp_factor < 1.0:
		var current_rotation = rotation.y
		rotation.y = lerp_angle(current_rotation, target_rotation, lerp_factor)
	else:
		rotation.y = target_rotation
	
	return true

func update_animation(anim_name: String) -> void:
	# Play animation if it exists and isn't already playing
	if animation_player.has_animation(anim_name) and animation_player.current_animation != anim_name:
		animation_player.play(anim_name, 0.5)  # Blend over 0.3 seconds
	if anim_name == "stun":
		animation_player.speed_scale = 3
	if anim_name != 'stun':
		animation_player.speed_scale = 1
		
func TakeDamage (hurt_box : Hurt_box ) -> void:
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
	pass
