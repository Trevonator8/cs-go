extends CharacterBody3D

@onready var animationTree : AnimationTree = $AnimationTree
@onready var animation_player = $TrueChappelCharacter/AnimationPlayer
@onready var left_hand_hitbox : Area3D = $LeftHandHitbox
@onready var left_hand : CollisionShape3D = $LeftHandHitbox/LeftHand
@onready var right_hand_hitbox : Area3D = $RightHandHitbox
@onready var right_hand : CollisionShape3D = $RightHandHitbox/RightHand
@onready var body_vuln : Area3D = $BodyVulnHitbox
@onready var body : CollisionShape3D = $BodyVulnHitbox/BodyVuln
@onready var head_vuln : Area3D = $HeadVulnHitbox
@onready var head : CollisionShape3D = $HeadVulnHitbox/HeadVuln
@onready var skeleton : Skeleton3D = $TrueChappelCharacter/MBlab_sk1732665696_6954129/Skeleton3D
@onready var healthBar : ProgressBar = $"../ChappelHealthBar"
var blocking = false
var facingRight = true
var alreadyWalkingRight = false
var alreadyWalkingLeft = false
var attacking = false
var hurting = false
var blockingLow = false
var blockingHigh = false


#var start_timer: bool = false

var speed = 5
@onready var slap_sound1 = $Slap1
#@onready var slap_sound2 = $Slap2	

var playerHealth = 10


func _ready():
	blockingLow = false
	blockingHigh = false
	hurting = false
	blocking = false
	facingRight = true
	attacking = false
	animationTree.active = false
	left_hand_hitbox.monitoring = false
	left_hand.disabled = true
	left_hand_hitbox.visible = false
	left_hand_hitbox.connect("area_entered", Callable(self, "_on_hand_hitbox_area_entered"))
	
	# Attach hitbox to the hand bone
	var bone_index = skeleton.find_bone("hand_L")
	if bone_index != -1:
		var bone_attachment = BoneAttachment3D.new()
		bone_attachment.name = "hand_L_attachment"
		bone_attachment.bone_name = "hand_L"
		skeleton.add_child(bone_attachment)
		
		# God has abandoned me in the Godot layout so I gotta do some weird shizzle
		# Remove hand_hitbox from its current parent and add it to the bone attachment
		remove_child(left_hand_hitbox)
		bone_attachment.add_child(left_hand_hitbox)
	
	right_hand_hitbox.monitoring = false
	right_hand.disabled = true
	right_hand_hitbox.visible = false
	right_hand_hitbox.connect("area_entered", Callable(self, "_on_hand_hitbox_area_entered"))
	
	bone_index = skeleton.find_bone("hand_R")
	if bone_index != -1:
		var bone_attachment = BoneAttachment3D.new()
		bone_attachment.name = "hand_R_attachment"
		bone_attachment.bone_name = "hand_R"
		skeleton.add_child(bone_attachment)
		
		remove_child(right_hand_hitbox)
		bone_attachment.add_child(right_hand_hitbox)
	animationTree.active = true
	# Connect the animation finished signal to handle hitbox deactivation
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	update_animation_parameters(delta)
	healthBar.value = playerHealth
	if playerHealth == 0:
		Engine.time_scale = 0
		$"../LawlorWins".visible = true
	if position.z < -2:
		position.z = -2
	if position.z > 5:
		position.z = 5


func update_animation_parameters(delta):
	var input_vector = Vector3.ZERO
	
	# Walk Right
	if Input.is_action_pressed("ChappelRight") and !blocking and !attacking and !hurting:
		animationTree["parameters/conditions/isWalking"] = true
		animationTree["parameters/conditions/idle"] = false
		head_vuln.monitoring = true
		head.disabled = false
		head_vuln.visible = true
		body_vuln.monitoring = true
		body.disabled = false
		body_vuln.visible = true
		input_vector.z += 1
		
		# If already walking left, reset the left movement flag
		if alreadyWalkingLeft:
			alreadyWalkingLeft = false
		
		alreadyWalkingRight = true
		
		# Turn character to face right if needed
		if (!facingRight):
			$TrueChappelCharacter.rotation.y += PI
			facingRight = true
	
	# Walk Left
	elif Input.is_action_pressed("ChappelLeft") and !blocking and !attacking and !hurting:
		animationTree["parameters/conditions/isWalking"] = true
		animationTree["parameters/conditions/idle"] = false
		head_vuln.monitoring = true
		head_vuln.visible = true
		head.disabled = false
		body_vuln.monitoring = true
		body_vuln.visible = true
		body.disabled = false
		input_vector.z -= 1
		
		# If already walking right, reset the right movement flag
		if alreadyWalkingRight:
			alreadyWalkingRight = false
		
		alreadyWalkingLeft = true
		
		# Turn character to face left if needed
		if (facingRight):
			rotation.y += PI
			facingRight = false
	
	# High and Low Attacks (Left)
	elif Input.is_action_just_pressed("ChappelLeftHigh") and !blocking and !hurting:
		animationTree["parameters/conditions/leftHigh"] = true
		animationTree["parameters/conditions/idle"] = false
		left_hand_hitbox.monitoring = true
		left_hand.disabled = false
		left_hand_hitbox.visible = true
		attacking = true
		animation_player.play("LeftHigh")
	
	elif Input.is_action_just_pressed("ChappelLeftLow") and !blocking and !hurting:
		animationTree["parameters/conditions/leftLow"] = true
		animationTree["parameters/conditions/idle"] = false
		left_hand_hitbox.monitoring = true
		left_hand.disabled = false
		left_hand_hitbox.visible = true
		attacking = true
		animation_player.play("LeftLow")
	
	# High and Low Attacks (Right)
	elif Input.is_action_just_pressed("ChappelRightHigh") and !blocking and !hurting:
		animationTree["parameters/conditions/rightHigh"] = true
		animationTree["parameters/conditions/idle"] = false
		right_hand_hitbox.monitoring = true
		right_hand.disabled = false
		right_hand_hitbox.visible = true
		attacking = true
		animation_player.play("RightHigh")
	
	elif Input.is_action_just_pressed("ChappelRightLow") and !blocking and !hurting:
		animationTree["parameters/conditions/rightLow"] = true
		animationTree["parameters/conditions/idle"] = false
		right_hand_hitbox.monitoring = true
		right_hand.disabled = false
		right_hand_hitbox.visible = true
		attacking = true
		animation_player.play("RightLow")
	
	# Blocking
	elif Input.is_action_pressed("ChappelGuardHigh") and !blockingLow:
		animationTree["parameters/conditions/guardHigh"] = true
		animationTree["parameters/conditions/idle"] = false
		blocking = true
		head_vuln.monitoring = false
		head.disabled = true
		head_vuln.visible = false
		blockingHigh = true
	
	elif Input.is_action_pressed("ChappelGuardLow") and !blockingHigh:
		animationTree["parameters/conditions/guardLow"] = true
		animationTree["parameters/conditions/idle"] = false
		blocking = true
		body_vuln.monitoring = false
		body.disabled = true
		body_vuln.visible = false
		blockingLow = true
	elif Input.is_action_just_pressed("ChappelSkinwalker"):
		animationTree["parameters/conditions/skinwalker"] = true
		animationTree["parameters/conditions/idle"] = false
	
	# Idle state
	elif !hurting:
		animationTree["parameters/conditions/guardHigh"] = false
		animationTree["parameters/conditions/guardLow"] = false
		animationTree["parameters/conditions/isWalking"] = false
		animationTree["parameters/conditions/leftHigh"] = false
		animationTree["parameters/conditions/leftLow"] = false
		animationTree["parameters/conditions/rightHigh"] = false
		animationTree["parameters/conditions/rightLow"] = false
		animationTree["parameters/conditions/skinwalker"] = false
		animationTree["parameters/conditions/idle"] = true
		blocking = false
		head_vuln.monitoring = true
		head.disabled = false
		head_vuln.visible = true
		body_vuln.monitoring = true
		body.disabled = false
		body_vuln.visible = true
		alreadyWalkingRight = false
		alreadyWalkingLeft = false
		blockingHigh = false
		blockingLow = false
	
	# Apply movement
	input_vector = input_vector.normalized()
	position += input_vector * speed * delta

func _on_animation_finished(anim_name):
	#print("Signal received for animation:", anim_name)
	if anim_name == "LeftHigh":
		left_hand_hitbox.monitoring = false
		left_hand.disabled = true
		left_hand_hitbox.visible = false
		attacking = false
	elif anim_name == "LeftLow":
		left_hand_hitbox.monitoring = false
		left_hand.disabled = true
		left_hand_hitbox.visible = false
		attacking = false
	elif anim_name == "RightHigh":
		right_hand_hitbox.monitoring = false
		right_hand.disabled = true
		right_hand_hitbox.visible = false
		attacking = false
	elif anim_name == "RightLow":
		right_hand_hitbox.monitoring = false
		right_hand.disabled = true
		right_hand_hitbox.visible = false
		attacking = false


#func _on_left_hand_hitbox_area_entered(area: Area3D) -> void:
	# Check if the entered area belongs to the Player2Vulnerable layer
	#if area.collision_layer & (1 << 2):
		#print("Hit detected with vulnerable area:", area.name)


#func _on_right_hand_hitbox_area_entered(area: Area3D) -> void:
	#if area.collision_layer & (1 << 2):
		#print("Hit detected with vulnerable area:", area.name)


func _on_head_vuln_hitbox_area_entered(area: Area3D) -> void:
	print("Chappel Hit In The Head")
	slap_sound1.play()
	hurt()


func _on_body_vuln_hitbox_area_entered(area: Area3D) -> void:
	print("Chappel Hit In The Body")
	slap_sound1.play()
	hurt()

func hurt():
	playerHealth -= 1
	body_vuln.set_deferred("monitoring", false)
	body.disabled = true
	body_vuln.visible = false
	head_vuln.set_deferred("monitoring", false)
	head.disabled = true
	head_vuln.visible = false
	right_hand_hitbox.set_deferred("monitoring", false)
	right_hand.disabled = true
	right_hand_hitbox.visible = false
	left_hand_hitbox.set_deferred("monitoring", false)
	left_hand.disabled = true
	left_hand_hitbox.visible = false
	attacking = false
	blockingHigh = false
	blockingLow = false
	animationTree["parameters/conditions/guardHigh"] = false
	animationTree["parameters/conditions/guardLow"] = false
	animationTree["parameters/conditions/isWalking"] = false
	animationTree["parameters/conditions/leftHigh"] = false
	animationTree["parameters/conditions/leftLow"] = false
	animationTree["parameters/conditions/rightHigh"] = false
	animationTree["parameters/conditions/rightLow"] = false
	animationTree["parameters/conditions/skinwalker"] = false
	animationTree["parameters/conditions/idle"] = false
	animationTree["parameters/conditions/hurt"] = true
	$Timer.start()
	hurting = true
	if !facingRight:
		position.z += speed*0.1
	else:
		position.z -= speed*0.1
	



func _on_timer_timeout() -> void:
	animationTree["parameters/conditions/idle"] = true
	animationTree["parameters/conditions/hurt"] = false
	body_vuln.monitoring = true
	body.disabled = false
	body_vuln.visible = true
	head_vuln.monitoring = true
	head.disabled = false
	head_vuln.visible = true
	hurting = false
