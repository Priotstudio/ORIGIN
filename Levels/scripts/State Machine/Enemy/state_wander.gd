class_name EnemyState_Wander extends Enemy_state

@export var anim_name: String = "walk"
@export var walk_speed: float = 1.0

@export_category("AI")
@export var state_animation_duration: float = 1.0  # Base duration per cycle
@export var state_cycles_min: int = 3  # Min cycles (3-10 seconds)
@export var state_cycles_max: int = 10  # Max cycles (10-30 seconds)
@export var pause_chance: float = 0.2  # 20% chance to pause per second
@export var pause_duration_min: float = 1.0  # Min pause time (for idle)
@export var pause_duration_max: float = 3.0  # Max pause time (for idle)
@export var look_around_chance: float = 0.5  # 50% chance to play look_around
@export var look_around_duration_min: float = 6.0  # Min look_around time
@export var look_around_duration_max: float = 10.0  # Max look_around time
@export var direction_change_interval_min: float = 2.0  # Min time before direction change
@export var direction_change_interval_max: float = 5.0  # Max time before direction change
@export var rotation_lerp_speed: float = 5.0  # Speed of rotation interpolation (higher = faster)
@export var collision_cooldown: float = 1.0  # Cooldown after hitting a wall
@export var next_state: Enemy_state

var _timer: float = 0.0
var _direction: Vector3
var _is_paused: bool = false
var _pause_timer: float = 0.0
var _direction_change_timer: float = 0.0
var _collision_cooldown_timer: float = 0.0
var _use_look_around: bool = false

func init() -> void:
	pass

func enter() -> void:
	# Set random duration for wandering
	_timer = randf_range(state_cycles_min, state_cycles_max) * state_animation_duration
	
	# Pick a random cardinal direction
	var rand_index = randi_range(0, Enemy.DIR_4.size() - 1)
	_direction = Enemy.DIR_4[rand_index]
	
	# Set initial velocity and direction
	enemy.velocity = _direction * walk_speed
	enemy.set_direction(_direction)  # Instant rotation on enter
	if enemy.animation_player.current_animation != anim_name:
		enemy.update_animation(anim_name)
	_is_paused = false
	_pause_timer = 0.0
	_direction_change_timer = randf_range(direction_change_interval_min, direction_change_interval_max)
	_collision_cooldown_timer = 0.0
	_use_look_around = false

func physics(delta: float) -> Enemy_state:
	if _is_paused:
		# Handle pause state
		_pause_timer -= delta
		var pause_anim = "look_around" if _use_look_around and enemy.animation_player.has_animation("look_around") else "idle"
		if enemy.animation_player.current_animation != pause_anim:
			enemy.update_animation(pause_anim)
		enemy.velocity = Vector3.ZERO
		if _pause_timer <= 0.0:
			# Resume wandering
			_is_paused = false
			_use_look_around = false
			if enemy.animation_player.current_animation != anim_name:
				enemy.update_animation(anim_name)
			enemy.velocity = _direction * walk_speed
			enemy.set_direction(_direction)  # Instant rotation on resume
		return null

	# Decrease timers
	_timer -= delta
	_direction_change_timer -= delta
	_collision_cooldown_timer -= delta
	
	# Randomly decide to pause
	if randf() < pause_chance * delta:
		_is_paused = true
		_use_look_around = randf() < look_around_chance
		# Use longer duration for look_around, shorter for idle
		if _use_look_around:
			_pause_timer = randf_range(look_around_duration_min, look_around_duration_max)
		else:
			_pause_timer = randf_range(pause_duration_min, pause_duration_max)
		return null
	
	# Periodic direction change
	if _direction_change_timer <= 0.0:
		var rand_index = randi_range(0, Enemy.DIR_4.size() - 1)
		_direction = Enemy.DIR_4[rand_index]
		_direction_change_timer = randf_range(direction_change_interval_min, direction_change_interval_max)
	
	# Obstacle avoidance via collision detection
	if _collision_cooldown_timer <= 0.0 and enemy.get_slide_collision_count() > 0:
		# Hit a wall, pick a new direction
		var rand_index = randi_range(0, Enemy.DIR_4.size() - 1)
		_direction = Enemy.DIR_4[rand_index]
		_direction_change_timer = randf_range(direction_change_interval_min, direction_change_interval_max)
		_collision_cooldown_timer = collision_cooldown
	
	# Apply slight randomness to speed for organic feel
	var current_speed = walk_speed * randf_range(0.9, 1.1)
	enemy.velocity = _direction * current_speed
	
	# Smoothly rotate to face direction
	var lerp_factor = clamp(delta * rotation_lerp_speed, 0.0, 1.0)
	enemy.set_direction(_direction, lerp_factor)
	
	# Transition to next state when timer expires
	if _timer <= 0.0:
		return next_state
	return null

func exit() -> void:
	# Stop movement and reset to idle
	enemy.velocity = Vector3.ZERO
	if enemy.animation_player.current_animation != "idle":
		enemy.update_animation("idle")
