class_name Enemy_state_Death extends Enemy_state

#const  PICKUP = preload("res://items/item_pickup/item_pickup.tscn")

@export var anim_name : String = "death"
#@export var knock_back_speed : float = 200.0
#@export var decelarate_speed : float = 10.0

@export_category("AI")

#@export_category("ItemDrops")
#@export var drop : Array[ Dropdata ]

var _damage_position : Vector3
var _direction : Vector3


func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass




func enter() -> void:
	#enemy.invalnurable = true
	#_direction = enemy.global_position.direction_to(_damage_position)

	#enemy.set_direction(_direction)
	#enemy.velocity = _direction * -knock_back_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	destroy_hurt_box()
	#drop_items()
	pass




# when player exist a state
func exit() -> void:
	
	pass
	
	

func process(_delta : float) -> Enemy_state:
	#enemy.velocity -= enemy.velocity * decelarate_speed * _delta
	return null
	
	
	
	
	
func physics (_dhurtelta : float) -> Enemy_state:
	return null



func _on_enemy_destroyed (hurt_box : Hurt_box) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)
	
	
func _on_animation_finished (_a : String) -> void:
	enemy.queue_free()
	

func destroy_hurt_box () -> void:
	var hurtBox : Hurt_box = enemy.get_node_or_null("hurt_box")
	if hurtBox:
		hurtBox.monitoring = false


#func drop_items () -> void:
	#if drop.size() == 0:
		#return
	#
	#for i in drop.size():
		#if drop[i] == null or drop[i].item == null:
			#continue
		#var drop_count : int = drop[i].get_drop_count()
		#for j in drop_count:
			#var drops = PICKUP.instantiate() as ItemPickup
			#drops.item_data = drop[i].item
			#enemy.get_parent().call_deferred("add_child", drops)
			#drops.global_position = enemy.global_position
			#drops.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
	#pass
