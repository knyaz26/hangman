extends Node2D

@onready var doom_timer: Timer = $doom_timer
var mystery_word
var used_chars = "."
var words #use tres not json again.

func _ready() -> void:
	words = load_json_file("res://words.json")
	pick_word_and_apply()
	reveal_a_couple_chars()
	start_a_doom_timer()

func _process(delta: float) -> void:
	if not $background/ColorRect.visible:
		update_timer_display()

	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://game/UI/main_menu.tscn")


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
	$UI/VBoxContainer/used_letters.text += new_text + ", "

func reveal_mystery_word(new_text):
	var found_match = false
	if mystery_word.contains(new_text):
		found_match = true
		for i in range(len(mystery_word)):
			if mystery_word[i] == new_text:
				if $UI/VBoxContainer/word.text[i * 2] == '_':
					$UI/VBoxContainer/word.text[i * 2] = new_text

		if not $UI/VBoxContainer/word.text.contains("_"):
			game_won()
			return

	if not found_match:
		damage()

func damage():
	if $background/ColorRect.visible:
		return

	if $background.frame == 4:
		game_lost()
	else:
		$background.frame += 1

func game_won():
	doom_timer.stop()
	$background/ColorRect.visible = true
	$background/ColorRect/Control/VBoxContainer/Label.text = "Congrats you won"
	$background/ColorRect/Control/VBoxContainer/Label2.text = "silly rat lives another day."
	$UI/VBoxContainer/HBoxContainer/LineEdit.editable = false

func game_lost():
	doom_timer.stop()
	$background/ColorRect.visible = true
	$background/ColorRect/Control/VBoxContainer/Label.text = "You lost again :("
	$background/ColorRect/Control/VBoxContainer/Label2.text = "look what you did. word(" + mystery_word + ")"
	$UI/VBoxContainer/HBoxContainer/LineEdit.editable = false

func _on_line_edit_text_changed(new_text: String) -> void:
	$Confirm.play()

func _on_line_edit_text_change_rejected(rejected_substring: String) -> void:
	$Error005.play()

func pick_word_and_apply():
	if words.is_empty():
		push_error("Word list is empty or failed to load!")
		mystery_word = "error"
	else:
		mystery_word = words[randi_range(0, words.size() - 1)]

	$UI/VBoxContainer/word.text = ""
	for i in range(len(mystery_word)):
		$UI/VBoxContainer/word.text += "_ "
	$UI/VBoxContainer/word.text = $UI/VBoxContainer/word.text.strip_edges(true, true)


func load_json_file(path : String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(content)
		if typeof(parsed) == TYPE_ARRAY:
			return parsed
		else:
			push_error("Failed to parse JSON or content is not an array in file: " + path)
			return []
	else:
		push_error("Failed to open file: " + path)
		return []

func reveal_a_couple_chars():
	if len(mystery_word) <= 1: return

	var reveal_1 = randi_range(0, len(mystery_word) - 1)
	reveal_character_at(reveal_1)

	if len(mystery_word) >= 4:
		var reveal_2 = randi_range(0, len(mystery_word) - 1)
		var attempts = 0
		while (reveal_2 == reveal_1 or mystery_word[reveal_2] == mystery_word[reveal_1]) and attempts < 10:
			reveal_2 = randi_range(0, len(mystery_word) - 1)
			attempts += 1

		if reveal_2 != reveal_1 and mystery_word[reveal_2] != mystery_word[reveal_1]:
			reveal_character_at(reveal_2)


func reveal_character_at(index : int):
	if index >= 0 and index < len(mystery_word):
		if $UI/VBoxContainer/word.text[index * 2] == '_':
			$UI/VBoxContainer/word.text[index * 2] = mystery_word[index]


func start_a_doom_timer():
	if not doom_timer.timeout.is_connected(game_lost):
		doom_timer.timeout.connect(game_lost)
	doom_timer.wait_time = 30
	doom_timer.one_shot = true
	doom_timer.start()


func update_timer_display():
	if not doom_timer.is_stopped():
		$UI/VBoxContainer/ColorRect/Label.text = str(doom_timer.time_left).substr(0, 5)
	else:
		pass
