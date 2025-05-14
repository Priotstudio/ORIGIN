extends Node

const PLAYER = preload("res://Levels/scenes/player.tscn")
#const  INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/inventory/player_inventory.tres")

var player: Player
var player_spawn : bool = false

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawn == true


func add_player_instance ( )-> void:
	player = PLAYER.instantiate()
	add_child(player)
	

func set_health (hp: int, max_hp : int) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp(0)


func set_player_position (_new_pos : Vector3) -> void:
	player.global_position = _new_pos
	pass

func set_next_parent (_p : Node3D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)
	
	
func un_parent_player (_P : Node3D) -> void:
	_P.remove_child(player)
