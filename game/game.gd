extends Node2D

@onready var words = [
	"ability", "abstract", "adventure", "algorithm", "analysis", "antique", "apology", "asteroid", "biology", 
	"bicycle", "calendar", "celebrate", "climate", "compiler", "conclusion", "convention", "create", "crystal", 
	"decimal", "destination", "document", "elephant", "equator", "fortune", "glimpse", "harmony", "horizon", 
	"identity", "imagine", "intelligent", "justice", "kingdom", "language", "laptop", "library", "marathon", "matrix", 
	"meteor", "molecule", "notebook", "ocean", "outline", "planet", "prison", "recycle", "reliable", "revolution", 
	"ripple", "scientific", "sentence", "software", "spectrum", "spirit", "theory", "universe", "vortex", "voyage", 
	"wonder", "yearbook", "zenith", "amplify", "analyze", "appetite", "ashore", "automate", "boiling", "brisk", 
	"circuit", "concord", "current", "damper", "dazzle", "decent", "delight", "diamond", "dynamo", "element", 
	"empathy", "expire", "famous", "frost", "giggle", "grand", "grape", "gravity", "haptic", "heroic", "hurricane", 
	"impress", "incisor", "injury", "inverse", "jargon", "jolt", "juggle", "keen", "kinetic", "lunar", "magnet", 
	"matrix", "nexus", "noble", "omega", "oscillate", "paradox", "particle", "pause", "quicksand", "quiver", 
	"reaction", "regale", "relative", "revolt", "rotate", "scenario", "segmentation", "sizzle", "summit", "symbol", 
	"tangent", "terabyte", "tranquil", "typhoon", "unison", "vivid", "whisper", "zeal", "zodiac", "dynamo", "eclipse", 
	"friction", "formula", "galaxy", "gravity", "hologram", "illusion", "inception", "laboratory", "lava", "luminous", 
	"magma", "metal", "neutron", "nova", "parallel", "quanta", "reform", "scrutiny", "spectrum", "tornado", "vibration", 
	"volatile", "whirlwind", "wavelength", "zeppelin", "absorb", "acquire", "analog", "athletic", "blaze", "breeze", 
	"blink", "calibrate", "cascade", "collide", "counsel", "deflect", "density", "depot", "deteriorate", "diverse", 
	"effort", "encourage", "exact", "extract", "fracture", "gather", "generate", "grind", "hatch", "hydrate", "ignite", 
	"inspire", "iron", "loop", "migrate", "nourish", "polarity", "pulse", "radiate", "respond", "scatter", "shield", 
	"signal", "stability", "storm", "synchronize", "tremor", "triumph", "vibrate", "vortex", "whirlpool", "abnormal", 
	"abundant", "adaptive", "announce", "audible", "balance", "breathe", "compress", "control", "digital", "distort", 
	"elevate", "encounter", "enhance", "evolve", "focus", "generate", "glow", "habitat", "hypothesis", "intensity", 
	"intuit", "lens", "matrix", "network", "optical", "oscillation", "outbreak", "penetrate", "plasma", "potential", 
	"pulse", "range", "reflection", "reliability", "restore", "sensory", "solar", "stress", "subtle", "theory", 
	"thread", "transmit", "vapor", "voltage", "warmth", "alchemy", "atom", "binary", "circuitry", "cognitive", "compound", 
	"crystal", "decode", "disrupt", "diversity", "examine", "filament", "fluid", "gravity", "harmonic", "impulse", 
	"influx", "interact", "molecular", "nucleus", "oscillation", "periodic", "saturate", "sensation", "stimulate", 
	"theoretical", "turbine", "unite", "vibration", "amplifier", "barrier", "clamp", "core", "decay", "equilibrium", 
	"fusion", "grounding", "inject", "magnetic", "modulate", "phase", "predicted", "react", "transverse", "velocity", 
	"voltage", "wire", "calculative", "error", "fallout", "fracture", "interference", "join", "limit", "solution", 
	"synchronize", "tangle", "zone", "horizon", "ignite", "modular", "optical", "stream", "xenon", "formulation"
]

var mystery_word
var chars_revealed = 0
var used_chars = "."

func _ready() -> void:
	mystery_word = words[randi_range(0, 313)]
	$UI/VBoxContainer/word.text = ""
	for i in range(len(mystery_word)):
		$UI/VBoxContainer/word.text += "_ "
	print(mystery_word)



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
	$background/ColorRect/Control/VBoxContainer/Label2.text = "look what you did."

func reset():
	pass


func _on_line_edit_text_changed(new_text: String) -> void:
	$Confirm.play()


func _on_line_edit_text_change_rejected(rejected_substring: String) -> void:
	$Error005.play()
