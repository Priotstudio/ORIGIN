class_name Computer_Area extends Area3D

@onready var audio_stream_player: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"
@onready var world_audio: AudioStreamPlayer3D = $"../../World_audio"
@onready var bg_audio: AudioStreamPlayer = $"../../bg_audio"
@onready var alarm: AudioStreamPlayer3D = $"../alarm"
@onready var door_open: AudioStreamPlayer3D = $"../door_open"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()
	bg_audio.play()
	body_entered.connect(AreaEnterd)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func AreaEnterd (p) -> void:
	if p is Player:
		world_audio.play()
		alarm.play()
		door_open.play()
		GameUi.end_dialogue()
		body_entered.disconnect(AreaEnterd)
	pass
