extends Control

## Onready
@onready var animation_player_crosshair: AnimationPlayer = $crosshair/AnimationPlayer
@onready var animation_player_dialouge: AnimationPlayer = $dialouge/AnimationPlayer
@onready var label_dialouge: Label = $dialouge/Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player_indicator: AnimationPlayer = $Indicator/AnimationPlayer
@onready var animation_player_hp: AnimationPlayer = $HP/AnimationPlayer
@onready var objecive_label: Label = $Objecive_label
@onready var indicator: Sprite2D = $Indicator


## Exports
@export_category("Sounds") ## Load expected sounds in inspector
@export var sound_mp3 : Resource
@export var sound1_mp3 : Resource
@export var sound2_mp3 : Resource
@export var sound3_mp3 : Resource
@export var sound4_mp3 : Resource
@export var sound5_mp3 : Resource

@export_category("Dialogue")
@export_multiline var dialogue_1 : String
@export_multiline var dialogue_2 : String 
@export_multiline var dialogue_3 : String 
@export_multiline var dialogue_4 : String 
@export_multiline var dialogue_5 : String 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player_hp.play("hp_up")
	animation_player_crosshair.play('idel')
	display_dialouge(dialogue_1)
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func display_dialouge (dialogue : String) -> void:
	# Wait 2 sec before displaying
	await get_tree().create_timer(6).timeout
	animation_player_dialouge.play('activate')
	audio_stream_player.stream = sound_mp3
	audio_stream_player.play()
	label_dialouge.text = dialogue
	
	# Wait before second dialogue
	await get_tree().create_timer(10).timeout
	audio_stream_player.stream = sound1_mp3
	audio_stream_player.play()
	label_dialouge.text = dialogue_2
	
	# Wait before third dialogue
	await get_tree().create_timer(12).timeout
	audio_stream_player.stream = sound1_mp3
	audio_stream_player.play()
	label_dialouge.text = dialogue_3
	animation_player_indicator.play("indicating")
	objecive_label.visible = true
	
	
	# Wait before deactivating
	await get_tree().create_timer(8).timeout
	animation_player_dialouge.play('deactivate')
	audio_stream_player.stream = sound2_mp3
	audio_stream_player.play()
	pass


func end_dialogue () -> void:
	# End dialogue
	animation_player_dialouge.play('activate')
	audio_stream_player.stream = sound_mp3
	audio_stream_player.play()
	label_dialouge.text = dialogue_4
	indicator.texture = load("res://Levels/sprites/Icon37.png")
	objecive_label.text = "OBJECTIVE: Mission Complete"
	
	# Await for next part
	await get_tree().create_timer(6).timeout
	audio_stream_player.stream = sound1_mp3
	audio_stream_player.play()
	label_dialouge.text = dialogue_5
	
	# Await before deactivating
	await get_tree().create_timer(8).timeout
	animation_player_dialouge.play('deactivate')
	audio_stream_player.stream = sound2_mp3
	audio_stream_player.play()
	print ("Reached here congrats")
	pass
