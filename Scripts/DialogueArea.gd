extends Area2D

export var dialogue_key = "" #Identifier in json file
var area_active = false

#Check if player is in area and interacted
func _input(event):
	if area_active and event.is_action_pressed("interact"):
		SignalBus.emit_signal("display_dialogue", dialogue_key) #Sends signal to SignalBus to display the dialogue of this key
	
	

func _on_DialogueArea_area_entered(area):
	area_active = true


func _on_DialogueArea_area_exited(area):
	area_active = false
