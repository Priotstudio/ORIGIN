class_name Hit_box extends Area3D

signal Damaged( damage : int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage ( hurt_box : Hurt_box ) -> void:
#	print ("TakeDamage: ", hurt_box.damage)
	Damaged.emit(hurt_box)
	pass
