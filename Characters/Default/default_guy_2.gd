extends CharacterBody3D

@onready var animationTree : AnimationTree = $AnimationTree
@onready var animation_player = $Default2/AnimationPlayer
@onready var hand_hitbox : Area3D = $HandHitbox 
@onready var skeleton : Skeleton3D = $Default2/MBlab_sk1731480214_0432518/Skeleton3D
@onready var slap_sound1 = $Slap1
@onready var slap_sound2 = $Slap2

func _ready():
	animationTree.active = false
	hand_hitbox.monitoring = false
	hand_hitbox.visible = false
	hand_hitbox.connect("area_entered", Callable(self, "_on_hand_hitbox_area_entered"))
	
	# Attach hitbox to the hand bone
	var bone_index = skeleton.find_bone("hand_L")
	if bone_index != -1:
		var bone_attachment = BoneAttachment3D.new()
		bone_attachment.name = "hand_L_attachment"
		bone_attachment.bone_name = "hand_L"
		skeleton.add_child(bone_attachment)
		
		# God has abandoned me in the Godot layout so I gotta do some weird shizzle
		# Remove hand_hitbox from its current parent and add it to the bone attachment
		remove_child(hand_hitbox)
		bone_attachment.add_child(hand_hitbox)
		
	animationTree.active = true
	# Connect the animation finished signal to handle hitbox deactivation
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	update_animation_parameters()

func update_animation_parameters():
	if Input.is_action_just_pressed("ui_up"):
		animationTree["parameters/conditions/isSlapping"] = true
		animationTree["parameters/conditions/idle"] = false
		hand_hitbox.monitoring = true
		hand_hitbox.visible = true
		animation_player.play("Slap")
	else:
		animationTree["parameters/conditions/isSlapping"] = false
		animationTree["parameters/conditions/idle"] = true

func _on_hand_hitbox_area_entered(area):
	# Check if the entered area belongs to the Player2Vulnerable layer
	if area.collision_layer & (1 << 2):
		print("Hit detected with vulnerable area:", area.name)
		# Add Logic Here
		# Sound Effect
		var random_choice = randi() % 2
		if random_choice == 0:
			slap_sound1.play()
		else:
			slap_sound2.play()

func _on_animation_finished(anim_name):
	if anim_name == "Slap":  # Make sure to check if it's the slap animation
		hand_hitbox.monitoring = false
		hand_hitbox.visible = false
