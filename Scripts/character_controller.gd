extends RigidBody3D

const SPEED = 10
const MAX_SPEED = 5
const DECELERATION_SPEED = 2

@onready var particles: GPUParticles3D = $Particles

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var vertical_dir := Input.get_axis("Down", "Up")
	var direction := (transform.basis * Vector3(input_dir.x, vertical_dir, input_dir.y)).normalized()
	if direction:
		apply_central_force(direction * SPEED)
		particles.emitting = true
		(particles.process_material as ParticleProcessMaterial).direction = -direction
	else:
		particles.emitting = false
		if linear_velocity.length() > 0:
			apply_central_force(-1 * linear_velocity * DECELERATION_SPEED)

	linear_velocity = linear_velocity.limit_length(MAX_SPEED)
