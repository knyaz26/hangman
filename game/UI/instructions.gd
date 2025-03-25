extends Control


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_ESCAPE):
		$Confirm.play()
		get_tree().change_scene_to_file("res://game/UI/main_menu.tscn")
