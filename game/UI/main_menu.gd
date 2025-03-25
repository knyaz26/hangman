extends Control


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_P):
		get_tree().change_scene_to_file("res://game/game.tscn")
	if Input.is_key_pressed(KEY_I):
		get_tree().change_scene_to_file("res://game/UI/instructions.tscn")
	if Input.is_key_pressed(KEY_Q):
		queue_free()
