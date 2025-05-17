class_name Hurt_box extends Area3D

@export var damage : int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect( AreaEntered )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func AreaEntered ( a : Area3D) -> void:
	if a is Hit_box:
		a.take_damage(self)
	pass
