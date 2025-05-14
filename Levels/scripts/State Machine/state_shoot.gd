extends State
class_name state_shoot

var SPEED : float = 3.0

# Bullet scene
var bullet_scene = preload("res://Levels/scenes/bullet.tscn")

@onready var walk: State = $"../walk"
@onready var jump: State = $"../jump"
@onready var idle: state_idle = $"../idle"
@onready var camera: Camera3D = $"../../camera/Marin/Camera3D"

@onready var ray_cast_gun: RayCast3D = $"../../camera/rifile/RayCast3D"
@onready var animation_player: AnimationPlayer = $"../../camera/rifile/AnimationPlayer"

# You can directly preload the shot sound here
var shot_sound = preload("res://Assets/Audio/shot.mp3")

# when the player enters this state
func Enter() -> void:
	animation_player.play("shoot")
	
	camera.apply_gun_shake()


	# 🔫 Create temporary audio player for this shot
	var shot_sound_player = AudioStreamPlayer3D.new()
	shot_sound_player.stream = shot_sound
	shot_sound_player.global_transform = ray_cast_gun.global_transform
	get_tree().current_scene.add_child(shot_sound_player)
	shot_sound_player.play()
	shot_sound_player.connect("finished", Callable(shot_sound_player, "queue_free"))

	# 💥 Instantiate bullet
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = ray_cast_gun.global_position

	# 🔀 Add random spread for realism
	var random_spread : float = 0.2
	var random_z = randf() * random_spread - (random_spread / 2)
	bullet_instance.transform.basis = ray_cast_gun.global_transform.basis
	bullet_instance.transform.basis.z += Vector3(0, 0, random_z)

	get_parent().add_child(bullet_instance)

func Exit() -> void:
	pass

func Process(_delta : float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * _delta
		return null

	if player.direction != Vector3.ZERO:
		return walk

	if player.direction == Vector3.ZERO:
		return idle

	player.velocity = Vector3.ZERO

	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		return jump

	return null

func Physics(_delta : float) -> State:
	return null

func HandleInput(_event : InputEvent) -> State:
	return null
