extends CPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blood_effect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#blood_effect()
	pass

func blood_effect () -> void:
	emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
	pass
