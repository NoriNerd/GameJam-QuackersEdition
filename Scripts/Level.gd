extends Node

export (String) var level_name = "FantasyWorld"

signal level_change(level_name) #Signal to change levels
var can_click = false #Allows world switching

var level_data := {
	"player_pos": Vector2(0,0)
}

func _ready() -> void:
	SignalBus.connect("update_level_data", self, "on_update_level_data")

func on_update_level_data(data_name):
	match data_name:
		"player_pos":
			level_data.player_pos = $DuckPlayer.position
		
		_:
			return
	

#Load data into this level
func load_level_data(new_level_data: Dictionary):
	level_data = new_level_data
	$DuckPlayer.position = level_data.player_pos
	
func enable_button():
	can_click = true

func cleanup():
	if $WorldSwitchSound.playing:
		yield($WorldSwitchSound, "finished")
	
	#Clean scene tree queue
	queue_free()


	
#Switch Worlds
func _input(event):
	if can_click and event.is_action_pressed("world_switch"):
		can_click = false #Disable clicking
		
		SignalBus.emit_signal("update_level_data", "player_pos")
		
		#Play sound
		$WorldSwitchSound.play()
		#Insert update position thingy
		emit_signal("level_change", level_name)
		
		
