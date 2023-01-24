extends Node

onready var current_level = $TestWorld
onready var anim = $AnimationPlayer

var next_level = null

#Connect to SignalBus
func _ready() -> void:
	current_level.connect("level_change", self, "handle_level_change")
	current_level.enable_button()
	

func handle_level_change(current_level_name: String):
	var next_level_name: String
	
	#Match each level to the ones it can switch to.
	match current_level_name: 
		"Reality":
			next_level_name = "Fantasy"
		"Test":
			next_level_name = "Reality"
		"Fantasy":
			next_level_name = "Test"
		
		#Catch all
		_:
			return
			
	
	next_level = load("res://Levels/" + next_level_name +"World.tscn").instance() #Store instance of next level
	next_level.z_index = -1 #Draw next level under current one
	add_child(next_level) #Add child to SceneSwitcher
	anim.play("fade_in")
	next_level.connect("level_change", self, "handle_level_change") #Connect the next scene to the scene switcher
	print(next_level_name)
	
	#Pass the data info
	transfer_data_between_scenes(current_level, next_level)
	
	
func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.load_level_data(old_scene.level_data)




func _on_AnimationPlayer_animation_finished(anim_name): #Gives animation name of finished animation
	match anim_name:
		"fade_in":
			current_level.cleanup() #Remove current level
			current_level = next_level #Change level
			current_level.z_index = 1 #Revert next level layer
			next_level = null #Free up next level
			
			anim.play("fade_out") 
		"fade_out":
			current_level.enable_button()
		
			
