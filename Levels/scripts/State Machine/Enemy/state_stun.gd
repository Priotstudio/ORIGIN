class_name Enemy_state_Stun extends Enemy_state

@export var anim_name : String = "stun"
@export var knock_back_speed : float = 200.0
@export var decelarate_speed : float = 10.0

@export_category("AI")
@export var next_state : Enemy_state

var _damage_position : Vector3
var _direction : Vector3
var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damage)

	pass




func enter() -> void:
	#enemy.invalnurable = true
	#_direction = enemy.global_position.direction_to(_damage_position)
	_animation_finished = false
	#enemy.set_direction(_direction)
	#enemy.velocity = _direction * -knock_back_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	pass




# when player exist a state
func exit() -> void:
	#enemy.invalnurable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass
	
	

func process(_delta : float) -> Enemy_state:
	if _animation_finished == true:
		return next_state
	#enemy.velocity -= enemy.velocity * decelarate_speed * _delta
	return null
	
	
	
	
	
func physics (_delta : float) -> Enemy_state:
	return null



func _on_enemy_damage (hurt_box : Hurt_box) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)
	
	
func _on_animation_finished (_a : String) -> void:
	_animation_finished = true
	
