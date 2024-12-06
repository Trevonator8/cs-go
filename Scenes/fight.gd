extends Node3D

var isPaused

@onready var PauseMenu = $"PauseMenu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isPaused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		PauseMenu.visible = !PauseMenu.visible
		if isPaused:
			Engine.time_scale = 1
			isPaused = false
		else:
			Engine.time_scale = 0
			isPaused = true


func _on_back_pressed() -> void:
	isPaused = false
