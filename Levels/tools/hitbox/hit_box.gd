class_name Hit_box extends Area3D

signal Damaged(damage: int)

var blood_effect_scene := preload("res://Levels/scenes/blood_spary.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func take_damage(hurt_box: Hurt_box) -> void:
	Damaged.emit(hurt_box)
	blood_spray(hurt_box.global_position)

func blood_spray(hit_position: Vector3) -> void:
	var blood_instance = blood_effect_scene.instantiate()
	add_child(blood_instance)
	blood_instance.global_position = hit_position
	
