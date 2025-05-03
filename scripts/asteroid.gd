extends Area2D

var movement_vector := Vector2(0, -1)
var speed := 50

enum AsteroidSize { LARGE, MEDIUM, SMALL } 
@export var size := AsteroidSize.LARGE

@onready var sprite: Sprite2D = $Sprite2D
@onready var cshape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	rotation = randf_range(0, 2 * PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			sprite.texture = preload("res://assets/meteorGrey_big4.png")
			cshape.shape = preload("res://resources/asteroid_cshape_big.tres")
		AsteroidSize.MEDIUM:
			speed = randf_range(100, 150)
			sprite.texture = preload("res://assets/meteorGrey_med2.png")
			cshape.shape = preload("res://resources/asteroid_cshape_med.tres")
		AsteroidSize.SMALL:
			speed = randf_range(100, 200)
			sprite.texture = preload("res://assets/meteorGrey_tiny1.png")
			cshape.shape = preload("res://resources/asteroid_cshape_tiny.tres")


func _physics_process(delta: float) -> void:
	self.global_position += movement_vector.rotated(rotation) * speed * delta
	
	var radius = cshape.shape.radius
	var screen_size := get_viewport_rect().size
	if global_position.y + radius < 0:
		global_position.y = screen_size.y + radius
	elif global_position.y - radius > screen_size.y:
		global_position.y = -radius
	if global_position.x + radius < 0:
		global_position.x = screen_size.x + radius
	elif global_position.x - radius > screen_size.x:
		global_position.x = -radius

func explode():
	pass
