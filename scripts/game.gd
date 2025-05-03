extends Node2D

@onready var lasers: Node = $Lasers
@onready var asteroids: Node = $Asteroids
@onready var hud: Control = $UI/HUD
@onready var game_over_screen: Control = $UI/GameOverScreen
@onready var player: CharacterBody2D = $Player
@onready var player_spawn_pos: Node2D = $PlayerSpawnPos

var asteroid_scene = preload("res://scenes/asteroid.tscn")

var score := 0:
	set(value):
		score = value
		hud.score = score

var lives: int:
	set(value):
		lives = value
		hud.init_lives(lives)

func _ready() -> void:
	game_over_screen.visible = false
	score = 0
	lives = 3
	player.connect("died", _on_player_died)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_player_laser_shot(laser: Variant) -> void:
	lasers.add_child(laser)
 
func _on_asteroid_exploded(pos, size, points):
	score += points
	for i in range(2): 
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass

func spawn_asteroid(pos, size):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)

func _on_player_died():
	lives -= 1
	if lives <= 0:
		await get_tree().create_timer(1.5).timeout
		game_over_screen.visible = true
	else:
		await get_tree().create_timer(1).timeout
		player.respawn(player_spawn_pos.global_position)
