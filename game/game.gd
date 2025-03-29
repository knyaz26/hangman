extends Node2D

var mystery_word
var chars_revealed = 0
var used_chars = "."
var words #use tres not json again.

func _ready() -> void:
	words = load_json_file("res://words.json") #technically tres but too lazy to change now.
	pick_word_and_apply()
	reveal_a_couple_chars()



func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://game/UI/main_menu.tscn")
		reset()

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text and !used_chars.contains(new_text):
		$Correct.play()
		used_chars += new_text
		reveal_mystery_word(new_text)
		reveal_new_keys(new_text)
	else:
		$Wrong.play()
	$UI/VBoxContainer/HBoxContainer/LineEdit.text = ""

func reveal_new_keys(new_text):
	$UI/VBoxContainer/used_letters.text += new_text +  ", "
	
func reveal_mystery_word(new_text):
	if mystery_word.contains(new_text):
		for i in range(len(mystery_word)):
			if mystery_word[i] == new_text:
				$UI/VBoxContainer/word.text[i * 2] = new_text
				chars_revealed += 1
				if chars_revealed == len(mystery_word):
					game_won()
	else:
		damage()
		
func damage():
	if $background.frame == 4:
		game_lost()
	$background.frame += 1
	
func game_won():
	$background/ColorRect.visible = true
	$background/ColorRect/Control/VBoxContainer/Label.text = "Congrats you won"
	$background/ColorRect/Control/VBoxContainer/Label2.text = "silly rat lives another day."
	
func game_lost():
	$background/ColorRect.visible = true
	$background/ColorRect/Control/VBoxContainer/Label.text = "You lost :("
	$background/ColorRect/Control/VBoxContainer/Label2.text = "look what you did. word(" + mystery_word + ")"

func reset():
	pass

func _on_line_edit_text_changed(new_text: String) -> void:
	$Confirm.play()

func _on_line_edit_text_change_rejected(rejected_substring: String) -> void:
	$Error005.play()
	
func pick_word_and_apply():
	mystery_word = words[randi_range(0, words.size())]
	$UI/VBoxContainer/word.text = ""
	for i in range(len(mystery_word)):
		$UI/VBoxContainer/word.text += "_ "
		
func load_json_file(path : String):
	return JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
	
func reveal_a_couple_chars():
	var reveal_2
	var reveal_1
	if len(mystery_word) > 3:
		reveal_1 = randi_range(0, len(mystery_word) - 1)
		reveal_2 = reveal_1
	if len(mystery_word) > 6:
		reveal_2 = randi_range(0, len(mystery_word) - 1)
	while reveal_1 == reveal_2:
		reveal_2 = randi_range(0, len(mystery_word) - 1)
	$UI/VBoxContainer/word.text[reveal_1] = mystery_word[reveal_1]
	$UI/VBoxContainer/word.text[reveal_2] = mystery_word[reveal_2]
