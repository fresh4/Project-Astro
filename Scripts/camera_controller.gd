extends SpringArm3D

var initial_camera_rotation: Vector3 = Vector3.ZERO
var rot_x = 0
var rot_y = 0
var camera_anglev = 0
var SENSITIVITY = 0.3

func _ready() -> void:
	initial_camera_rotation = rotation

func _input(event: InputEvent) -> void:
	# Handle 'camera snap' if button is clicked and released within the timeframe
	if Input.is_action_just_pressed("Camera Snap"):
		await get_tree().create_timer(0.2).timeout
		if not Input.is_action_pressed("Camera Snap"):
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation", initial_camera_rotation, 0.2)
			camera_anglev = 0
			return
	
	# Handle camera movement with mouse
	if Input.is_action_pressed("Camera Snap") and event is InputEventMouseMotion:
		rotate_camera(Vector2(event.relative.x, event.relative.y))
	# TODO: Handle camera movement with controller
	var input_dir := Input.get_vector("Camera Left", "Camera Right", "Camera Down", "Camera Up")
	if input_dir:
		Input.warp_mouse(Vector2(720,369))
		rotate_camera(input_dir*1.25)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func rotate_camera(direction: Vector2) -> void:
	# TODO: Simplify
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	rotate_y(deg_to_rad(-direction.x * SENSITIVITY))
	var changev = -direction.y * SENSITIVITY
	if camera_anglev + changev > -50 and camera_anglev + changev < 50:
		camera_anglev += changev
		rotate_x(deg_to_rad(changev))
	
	rotation.z = 0 # Lock rotation on the Z axis
	
