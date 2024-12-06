extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($"Audio Options/VBoxContainer/MasterSlider".value))
	AudioServer.set_bus_volume_db(1, linear_to_db($"Audio Options/VBoxContainer/SFXSlider".value))
	AudioServer.set_bus_volume_db(2, linear_to_db($"Audio Options/VBoxContainer/MusicSlider".value))

func _on_back_pressed() -> void:
	var optionsScn = $"."
	optionsScn.visible = !optionsScn.visible
	var MenuStuff = $"../VBoxContainer"
	MenuStuff.visible = !MenuStuff.visible
	var TitleLabel = get_node_or_null("../Title")
	if TitleLabel != null:
		TitleLabel.visible = !TitleLabel.visible
