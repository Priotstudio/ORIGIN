class_name Player extends CharacterBody3D


const SPEED : float = 250.0
const JUMP_VELOCITY = 4.5
const BOB_FRQ = 2.0
const BOb_AMP = 0.08

var t_bob = 0.0
var bullet_shot: int = 0

# for some reason the ammo count adds 2 times, sof if you want to shoot 5 times you must set 
# it to 10
var assualt_ammo : int = 10
var shotgun_ammo : int = 10
var chain_gun : int = 10

# for storing main ammo from which gun is in use
var main_ammo : int

#@onready var camera_3d: Camera3D = $rifile/Camera3D

@onready var camera: Node3D = $camera
@onready var player: CharacterBody3D = $"."
@onready var state_machine: PlayerStateMAchine = $StateMachine
@onready var jump: State = $StateMachine/jump
@onready var animation: AnimationPlayer = $camera/Marin/AnimationPlayer
@onready var animation_player: AnimationPlayer = $camera/rifile/AnimationPlayer


@onready var marin: Node3D = $camera/Marin
@onready var rifile: Node3D = $camera/rifile
@onready var shotgun: Node3D = $camera/shotgun
@onready var chaingun: Node3D = $camera/chaingun

@export var weapon_slot : Array[Node3D]

var current_weapon := 0

var min_range_below : float = -40.5
var max_range_above : float = 40.5
var horizontal : float = 0.5
var vartical : float = 0.5
var direction : Vector3 = Vector3.ZERO



func _ready() -> void:
	state_machine.Initialize(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	main_ammo = assualt_ammo
	pass
	
	
func _input(event) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(deg_to_rad(-event.relative.x * horizontal))
		camera.rotate_x(deg_to_rad(-event.relative.y * vartical))
		
	
		
		# camera upward and downward rotate limit
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(min_range_below), deg_to_rad(max_range_above))
	
		# Gamepad right stick input
	
	

func _physics_process(_delta: float) -> void:
	

	move_and_slide()
	
func _process(_delta: float) -> void:
	# Get the raw input direction
	var raw_direction = Vector3(
		Input.get_axis("left", "right"),
		0,
		Input.get_axis("up", "down")
	).normalized()
	direction = global_transform.basis * raw_direction  # Update direction
	
	#if Input is InputEventJoypadMotion:
	var look_x = Input.get_axis("camera_left", "camera_right")  # Right stick X
	var look_y = Input.get_axis("camera_up", "camera_down")      # Right stick Y
	if abs(look_x) > 0.2 or abs(look_y) > 0.2:  # Additional deadzone
		player.rotate_y(deg_to_rad(-look_x * horizontal * SPEED * get_process_delta_time()))
		camera.rotate_x(deg_to_rad(-look_y * vartical * SPEED * get_process_delta_time()))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(min_range_below), deg_to_rad(max_range_above))
	
	
	# to switch weapons
	if Input.is_action_just_pressed("switch_weapon"):
		_next_weapon()

func update_animation(state : String) -> void:
	animation.play(state)
	
func _headbob(_t_bob):
	var pos = Vector3.ZERO
	pos.y = sin(_t_bob * BOB_FRQ) * BOb_AMP
	return pos


func _next_weapon ():
	
	if weapon_slot[current_weapon] == $camera/rifile:
		print("yes")
	
	weapon_slot[current_weapon].visible = false
	current_weapon = (current_weapon + 1) % weapon_slot.size()
	weapon_slot[current_weapon].visible = true
	
	
	#print ("switched to ", weapon_slot[current_weapon])
