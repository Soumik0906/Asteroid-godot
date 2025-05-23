class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal died

@export var acceleration := 10.0
@export var max_speed := 750.0
@export var deceleration := 3.0
@export var rotation_speed := 250.0

@onready var muzzle: Node2D = $Muzzle
@onready var sprite: Sprite2D = $Sprite2D
@onready var cshape: CollisionPolygon2D = $CollisionPolygon2D

var laser_scene = preload("res://scenes/laser.tscn")

var can_shoot = true
var rate_of_fire = 0.15
var alive = true

func _process(delta: float) -> void:
	if !alive: return
	
	if can_shoot and Input.is_action_pressed("shoot"):
		can_shoot = false
		shoot_laser()
		await get_tree().create_timer(rate_of_fire).timeout
		can_shoot = true

func _physics_process(delta: float) -> void:
	if !alive: return
	
	var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward"))
		
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	# Handle right rotation
	if Input.is_action_pressed("rotate_right"):
		self.rotate(deg_to_rad(rotation_speed * delta))
	
	# Handle left rotation
	if Input.is_action_pressed("rotate_left"):
		self.rotate(-deg_to_rad(rotation_speed * delta))
	
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

func shoot_laser():
	var l = laser_scene.instantiate() 
	l.global_position = muzzle.global_position
	l.rotation = self.rotation
	emit_signal("laser_shot", l)

func die():
	if alive:
		alive = false
		sprite.visible = false
		cshape.set_deferred("disabled", true)
		emit_signal("died")

func respawn(pos):
	if !alive:
		alive = true
		self.global_position = pos
		self.velocity = Vector2.ZERO
		sprite.visible = true
		cshape.set_deferred("disabled", false)
