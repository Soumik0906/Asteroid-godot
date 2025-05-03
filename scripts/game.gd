extends Node2D

@onready var lasers: Node = $Lasers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_player_laser_shot(laser: Variant) -> void:
	lasers.add_child(laser)
