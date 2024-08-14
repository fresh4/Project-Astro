extends RigidBody3D

const SPEED: float = 5.0
const MAX_SPEED: float = 5.0
const DECELERATION_SPEED: float = 2.0

@onready var particles: GPUParticles3D = $Particles
@onready var camera_arm: SpringArm3D = $SpringArm3D

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var vertical_dir := Input.get_axis("Down", "Up")
	var direction := (transform.basis * Vector3(input_dir.x, vertical_dir, input_dir.y)).normalized()
	
	var forward: Vector3 = (-camera_arm.global_transform.basis.z*Vector3(1, 0, 1)).normalized()
	var side = (-camera_arm.global_transform.basis.x*Vector3(1, 0, 1)).normalized()
	var up = Vector3(0, vertical_dir, 0).normalized()
	
	# TODO: See about refactoring to eliminate conditionals
	if direction:
		var final_direction: Vector3 = Vector3.ZERO
		
		if Input.is_action_pressed("Forward"):
			final_direction += forward
		elif Input.is_action_pressed("Backward"):
			final_direction += -forward
		if Input.is_action_pressed("Left"):
			final_direction += side
		elif Input.is_action_pressed("Right"):
			final_direction += -side
		if Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
			final_direction += up
		
		apply_central_force(final_direction * SPEED)
		
		particles.emitting = true
		(particles.process_material as ParticleProcessMaterial).direction = -final_direction
	else:
		particles.emitting = false
		if linear_velocity.length() > 0:
			apply_central_force(-1 * linear_velocity * DECELERATION_SPEED)

	linear_velocity = linear_velocity.limit_length(MAX_SPEED)
