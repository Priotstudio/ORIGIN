extends State
class_name state_shoot

var SPEED : float = 3.0

# Bullet scene
var bullet_scene = preload("res://Levels/scenes/bullet.tscn")

@onready var walk: State = $"../walk"
@onready var jump: State = $"../jump"
@onready var idle: state_idle = $"../idle"

@onready var shoot: state_shoot = $"."
@onready var jump_and_shoot: state_jump_and_shoot = $"../jump and shoot"
@onready var camera: Camera3D = $"../../camera/Marin/Camera3D"
@onready var ray_cast_gun: RayCast3D = $"../../camera/RayCast3D"
@onready var animation_player: AnimationPlayer = $"../../camera/rifile/AnimationPlayer"

# You can directly preload the shot sound here
var shot_sound = preload("res://Assets/Audio/shot.mp3")

# Amount of shot the gun can shoot max 60
#var bullet_shot : int

var main_animation : StringName = 'shoot'
var next_animation : StringName = 'idle'

# when the player enters this state
func Enter() -> void:
	
	
	
	## A safe check to see if it still reloading, if so leave the function
	if player.bullet_shot >= player.main_ammo:
		return
	else:
		if player.weapon_slot[player.current_weapon] == $"../../camera/rifile":
			main_animation = 'shoot'
			animation_player.play(main_animation)
		elif player.weapon_slot[player.current_weapon] == $"../../camera/shotgun":
			
			main_animation = 'shoot_shotgun'
			animation_player.play(main_animation)
	
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
	var random_spread : float = 0.1
	var random_z = randf() * random_spread - (random_spread / 2)
	bullet_instance.transform.basis = ray_cast_gun.global_transform.basis
	bullet_instance.transform.basis.z += Vector3(0, 0, random_z)

	get_parent().add_child(bullet_instance)
	
	## check if the current animation is shoot, then add +1 to the bullet counter
	## make a safe disconnect on the _on_animation_player_animation_finished func and connect.
	
	if animation_player.current_animation == main_animation:
		player.bullet_shot += 1
		animation_player.animation_finished.disconnect(self._on_animation_player_animation_finished)
		animation_player.animation_finished.connect(_on_animation_player_animation_finished)
		
	## check if the user pressed the ahoot button, then check if the current animation is idle
	## to play the shoot animation and add another check if the aniamtion the current animation is shoot
	## to add to the counter again and safe disconnect and connect.
	
	if GameUi.reload_animation.is_playing():
		if Input.is_action_pressed("shoot"):
			return
	else:
		if Input.is_action_pressed("shoot"):
			
			if animation_player.current_animation == 'idle':
				animation_player.play(main_animation)
				
			if animation_player.current_animation == main_animation:
				animation_player.animation_finished.disconnect(self._on_animation_player_animation_finished)
				animation_player.animation_finished.connect(_on_animation_player_animation_finished)
			
			
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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	## check if the counter is >= 5 for the assult rifile, if the animation name is shoot
	## Play the next animation and reload animation for assult rifile
	## wait 3 sce and reset the counter
	
	if player.bullet_shot >= player.main_ammo :
		if anim_name == "shoot" or 'shoot_shotgun':
			var reload_animation : String = "reload_rifile"
			next_animation = 'idle'
			animation_player.play(next_animation)
			GameUi.reload_show(reload_animation)
			await get_tree().create_timer(3).timeout
			
			player.bullet_shot = 0
				
	pass # Replace with function body.
