class_name Chase_Action
extends Area3D

signal chase_target_found(player: Player)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		chase_target_found.emit(body)
