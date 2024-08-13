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
	
	# Handle camera movement
	if Input.is_action_pressed("Camera Snap") and event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		var changev = -event.relative.y * SENSITIVITY
		if camera_anglev + changev > -50 and camera_anglev + changev < 50:
			camera_anglev += changev
			rotate_x(deg_to_rad(changev))
		
		rotation.z = 0 # Lock rotation on the Z axis
	
