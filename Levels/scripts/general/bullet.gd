extends Node3D

const SPEED: float = 79.0  # Realistic speed (was 1.0)

@onready var bullet: Node3D = $Sketchfab_Scene
@onready var decel = preload("res://Levels/scenes/bullet_decal.tscn")

func _ready() -> void:
	## Debug: Print initial position and forward direction
	#print("Bullet spawned at: ", global_position)
	#print("Bullet forward: ", transform.basis.z)
	pass

func _physics_process(delta: float) -> void:
	# Move bullet forward (using transform.basis.z as confirmed)
	var forward = transform.basis.z
	var next_position = global_position + forward * SPEED * delta

	# Raycast in the forward direction
	var ray_params = PhysicsRayQueryParameters3D.create(global_position, next_position)
	var result = get_world_3d().direct_space_state.intersect_ray(ray_params)

	if result:
		var hit_position = result.position
		var hit_normal = result.normal.normalized()

		var decel_instance = decel.instantiate()
		get_tree().current_scene.add_child(decel_instance)
		
		# Fade out after 2 seconds
		var timer = Timer.new()
		timer.wait_time = 2.0
		timer.one_shot = true
		decel_instance.add_child(timer)
		timer.start()

		timer.timeout.connect(func():
			var tween = decel_instance.create_tween()
			tween.tween_property(decel_instance, "modulate:a", 0.0, 1.0)
			tween.tween_callback(decel_instance.queue_free)
		)

		var decal_forward = -hit_normal
		var up = Vector3.UP
		if abs(decal_forward.dot(Vector3.UP)) > 0.99:
			up = Vector3.FORWARD

		var right = up.cross(decal_forward).normalized()
		up = decal_forward.cross(right).normalized()
		var basis = Basis(right, up, decal_forward)

		decel_instance.global_transform = Transform3D(basis, hit_position + hit_normal * 0.01)
		decel_instance.scale = Vector3.ONE * 0.04

		bullet.visible = false
		queue_free()
	else:
		global_position = next_position
