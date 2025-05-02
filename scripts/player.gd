extends CharacterBody2D

@export var acceleration := 10.0
@export var max_speed := 750.0
@export var deceleration := 3.0
@export var rotation_speed := 250.0

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward"))
		
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	# Handle right rotation
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	
	# Handle left rotation
	if Input.is_action_pressed("rotate_left"):
		rotate(-deg_to_rad(rotation_speed * delta))
	
	# Implement friction
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
	
	move_and_slide()
	
	# Boundary condition of spaceship
	var screen_size := get_viewport_rect().size
	
	# Y axis boundary
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	
	# X axis boundary
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
