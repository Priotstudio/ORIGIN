extends RayCast3D

signal seen_player(player: Player)  # Your existing single signal
signal lost_player()

var locked_player : Player = null

func _process(_delta: float) -> void:
	force_raycast_update()
	
	if is_colliding():
		var collider = get_collider()
		
		# Wall detection
		if collider.get_collision_layer_value(2):  # Layer 2 = "wall"
			if locked_player != null:
				locked_player = null
				lost_player.emit()
			return
			
		# Player detection
		if collider is Player:
			# Emit every frame while player is visible
			seen_player.emit(collider)  # Continuous emission
			locked_player = collider
	elif locked_player != null:
		locked_player = null
		lost_player.emit()
