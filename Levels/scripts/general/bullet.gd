class_name Bullet extends Node3D

const SPEED: float = 60.0  # Realistic speed (was 1.0)

@onready var bullet: Node3D = $Sketchfab_Scene
@onready var decel = preload("res://Levels/scenes/bullet_decal.tscn")
@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _ready() -> void:
	## Debug: Print initial position and forward direction
	#print("Bullet spawned at: ", global_position)
	#print("Bullet forward: ", transform.basis.z)
	pass

#func _physics_process(delta: float) -> void:
	## Move bullet forward (using transform.basis.z as confirmed)
	#
		#
		

func _physics_process(delta: float) -> void:
	var forward = transform.basis.z
	global_position += forward * SPEED * delta

	# Update raycast
	ray_cast_3d.global_position = global_position
	ray_cast_3d.target_position = forward * SPEED * delta * 2  # Look slightly ahead
	ray_cast_3d.force_raycast_update()
	
	
		
		## For placing decal on surface code
		#var d = decel.instantiate()
		#get_tree().current_scene.add_child(d)  # Or use a specific decal container
		#
		## Position with small offset to prevent z-fighting
		#d.global_position = ray_cast_3d.get_collision_point()
	#
		#var decal_forward = -hit_normal
		#var up = Vector3.UP
		#if abs(decal_forward.dot(Vector3.UP)) > 0.99:
			#up = Vector3.FORWARD
#
		#var right = up.cross(decal_forward).normalized()
		#up = decal_forward.cross(right).normalized()
		#var basis = Basis(right, up, decal_forward)
#
		#d.global_transform = Transform3D(basis, hit_position + hit_normal * 0.01)
		##d.scale = Vector3.ONE * 0.04
	await get_tree().create_timer(2).timeout
	queue_free()
