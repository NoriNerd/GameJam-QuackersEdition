extends CanvasLayer

#Put in JSON File
export (String, FILE, "*json") var scene_text_file
export var scroll_speed = 0.05


var scene_text = {} #Dictionary of all text needed in a scene
var selected_text = [] #Text currently used in player
var line_text = ""
var in_progress = false #Is player on
var typing = false
var skip = false

#UI Refs
onready var background = $Background
onready var dialogue_text = get_node("DialogueText")
onready var name_text = get_node("NameText")


func _ready():
	dialogue_text.text = ""
	name_text.text = ""
	background.visible = false #Turn off dialogue player
	scene_text = load_scene_text() 
	SignalBus.connect("display_dialogue", self, "on_display_dialogue") #Connect signalbus to self

func load_scene_text():
	#Create file, read json into it, make json text
	var file = File.new()
	if file.file_exists(scene_text_file):
		file.open(scene_text_file, File.READ)
		return parse_json(file.get_as_text())
		
func show_text():
	typing = true
	
	line_text = selected_text.pop_front() #Takes first item in array and removes it from array
	var current_text = ""
	var name_break = line_text.find(":")
	
	name_text.text = line_text.substr(0, name_break)
	line_text = line_text.substr(name_break + 1,-1)
	for i in range(len(line_text)):
		if skip:
			break
		current_text += line_text[i]
		dialogue_text.text = current_text
		yield(get_tree().create_timer(scroll_speed), "timeout")
	
	typing = false
	skip = false

	
func next_line():
	if selected_text.size() > 0: #If still elements in the text, show it
		show_text()
	else:
		finish()

func skip_line():
	skip = true
	dialogue_text.text = line_text
	
	

func finish():
	dialogue_text.text = ""
	name_text.text = ""
	background.visible = false
	in_progress = false
	SignalBus.emit_signal("interact")
	

func on_display_dialogue(text_key):
	if in_progress and not typing:
		next_line() #Progress dialogue
	elif typing:
		skip_line()
	elif not in_progress:
		SignalBus.emit_signal("interact")
		background.visible = true
		in_progress = true
		
		selected_text = scene_text[text_key].duplicate() #Duplicate text entry based on key
		show_text()

