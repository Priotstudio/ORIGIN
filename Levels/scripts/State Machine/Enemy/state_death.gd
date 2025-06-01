class_name Enemy_state_Death extends Enemy_state

#const PICKUP = preload("res://items/item_pickup/item_pickup.tscn")

@export var anim_name: String = "death"
#@export var knock_back_speed: float = 200.0
#@export var decelarate_speed: float = 10.0

@onready var line_of_sight: RayCast3D = $"../../line_of_sight"
@onready var collision_shape: CollisionShape3D = $"../../Hit_box/CollisionShape3D"
@onready var collision_enemy: CollisionShape3D = $"../../CollisionShape3D"
@onready var audio_stream_player: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"

@export_category("AI")
#@export_category("ItemDrops")
#@export var drop: Array[Dropdata]

@export_category("Sounds") ## Load expected sounds in inspector
@export var sound_mp3 : Resource
@export var sound1_mp3 : Resource
@export var sound2_mp3 : Resource
@export var sound_wav : Resource
@export var sound1_wav : Resource
@export var sound2_wav : Resource

var _damage_position: Vector3

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	
	pass

func enter() -> void:
	#enemy.invulnerable = true
	#_direction = enemy.global_position.direction_to(_damage_position)
	#enemy.set_direction(_direction)
	#enemy.velocity = _direction * -knock_back_speed
	
	enemy.update_animation(anim_name)
	# Connect the signal only if not already connected
	if not enemy.animation_player.animation_finished.is_connected(_on_animation_finished):
		enemy.animation_player.animation_finished.connect(_on_animation_finished)
	destroy_hurt_box()
	audio_stream_player.stream = sound_mp3
	audio_stream_player.volume_db = 1
	audio_stream_player.unit_size = 20
	audio_stream_player.pitch_scale = 1
	audio_stream_player.play()
	#drop_items()
	pass

# When player exits a state
func exit() -> void:
	# Disconnect the signal when exiting to avoid duplicate connections
	if enemy.animation_player.animation_finished.is_connected(_on_animation_finished):
		enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	audio_stream_player.stop()
	pass

func process(_delta: float) -> Enemy_state:
	#enemy.velocity -= enemy.velocity * decelarate_speed * _delta
	return null

func physics(_delta: float) -> Enemy_state:
	return null

func _on_enemy_destroyed(hurt_box: Hurt_box) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)

func _on_animation_finished(_a: String) -> void:
	## Delete the enemy after the death animation
	collision_shape.disabled = true
	#collision_enemy.disabled = true
	#enemy.queue_free()
	pass

func destroy_hurt_box() -> void:
	var hurt_box: Hurt_box = enemy.get_node_or_null("hurt_box")
	if hurt_box:
		hurt_box.monitoring = false

#func drop_items() -> void:
#    if drop.size() == 0:
#        return
#
#    for i in drop.size():
#        if drop[i] == null or drop[i].item == null:
#            continue
#        var drop_count: int = drop[i].get_drop_count()
#        for j in drop_count:
#            var drops = PICKUP.instantiate() as ItemPickup
#            drops.item_data = drop[i].item
#            enemy.get_parent().call_deferred("add_child", drops)
#            drops.global_position = enemy.global_position
#            drops.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
#    pass
