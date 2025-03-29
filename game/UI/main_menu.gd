extends Control


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_P):
		$Confirm.play()
		get_tree().change_scene_to_file("res://game/game.tscn")
	if Input.is_key_pressed(KEY_I):
		$Confirm.play()
		get_tree().change_scene_to_file("res://game/UI/instructions.tscn")
	if Input.is_key_pressed(KEY_Q):
		$Confirm.play()
		get_tree().quit()
