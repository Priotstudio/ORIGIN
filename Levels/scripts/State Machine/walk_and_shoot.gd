class_name state_walk_and_shoot extends State

var fire_delay: float = 0.01  # Time between shots
var time_since_last_shot: float = 0.0

var SPEED: float = 10.0  # Match state_walk
var bullet = load("res://Levels/scenes/bullet.tscn")
var instance

@onready var walk: State = $"../walk"
@onready var jump: State = $"../jump"
@onready var shoot: State = $"../shoot"
@onready var idle: State = $"../idle"
@onready var jump_and_shoot: state_jump_and_shoot = $"../jump and shoot"
@onready var ray_cast_gun: RayCast3D = $"../../camera/rifile/RayCast3D"
@onready var gun_animation: AnimationPlayer = $"../../camera/rifile/AnimationPlayer"
@onready var camera: Camera3D = $"../../camera/Marin/Camera3D"


func Enter() -> void:
	time_since_last_shot = 0.0
	_shoot()  # Fire on enter
	print("Entered state_walk_and_shoot")

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	time_since_last_shot += _delta

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * _delta
		return jump_and_shoot

	if player.direction == Vector3.ZERO:
		return idle

	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		return jump

	if Input.is_action_pressed("shoot") and time_since_last_shot >= fire_delay:
		_shoot()  # Fire while walking

	player.velocity.x = player.direction.x * SPEED
	player.velocity.z = player.direction.z * SPEED

	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null

func _shoot() -> void:
	time_since_last_shot = 0.0
	gun_animation.play("shoot")

	var shot = AudioStreamPlayer3D.new()
	shot.stream = preload("res://Assets/Audio/shot.mp3")
	shot.volume_db = 0
	shot.global_transform = ray_cast_gun.global_transform
	shot.pitch_scale = randf_range(0.9, 1.1)  # Match state_shoot
	get_tree().current_scene.add_child(shot)
	shot.play()
	shot.connect("finished", Callable(shot, "queue_free"))

	instance = bullet.instantiate()
	instance.name = "Bullet_" + str(randi())
	instance.position = ray_cast_gun.global_position
	var random_spread: float = 0.2
	var random_z = randf() * random_spread - (random_spread / 2)
	instance.transform.basis = ray_cast_gun.global_transform.basis
	instance.transform.basis.z += Vector3(0, 0, random_z)
	get_parent().add_child(instance)

	# Camera shake
	if camera:
		camera.shake()

	# Debug for wall issue
	print("Shot fired (walk_and_shoot), bullet ", instance.name, " at: ", instance.global_position)
	print("Muzzle position: ", ray_cast_gun.global_position)
	print("Player position: ", player.global_position)
	print("Parent: ", instance.get_parent().name)
