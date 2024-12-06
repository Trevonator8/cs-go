extends Camera3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_speed = 5
	var input_vector = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_vector -= transform.basis.z  # Move forward (negative Z)
	if Input.is_action_pressed("move_back"):
		input_vector += transform.basis.z  # Move backward (positive Z)
	if Input.is_action_pressed("move_right"):
		input_vector += transform.basis.x  # Move right (positive X)
	if Input.is_action_pressed("move_left"):
		input_vector -= transform.basis.x  # Move left (negative
	if Input.is_action_pressed("rot_left"):
		rotation_degrees.y -= 3
	if Input.is_action_pressed("rot_right"):
		rotation_degrees.y += 3
	if Input.is_action_pressed("rot_down"):
		rotation_degrees.x -= 3
	if Input.is_action_pressed("rot_up"):
		rotation_degrees.x += 3
	# Normalize the input vector to maintain consistent speed
	input_vector = input_vector.normalized()
	# Apply the movement relative to the object’s facing direction
	position += input_vector * move_speed * delta
