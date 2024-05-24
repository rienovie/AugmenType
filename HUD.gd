extends Node

@export var panelSettings : PanelContainer
@export var animationNode : AnimationPlayer
@export var colorPick : ColorPickerButton

var bSettingsPanelOpen : bool = false

func _ready() -> void:
	G.connect("colorUpdated",updatePanelColor)
	if(!colorPick):
		push_error("Color Picker not set in HUD!")
	else:
		var c = G.mainColor
		c *= G.bgColorMod
		c.a = 1
		colorPick.color = c
	updatePanelColor(G.mainColor)

func _on_btn_settings_pressed() -> void:
	if(!panelSettings):
		push_error("Panel not set!")
		return
	if(!animationNode):
		push_error("Animation Node not set!")
		return
	if(bSettingsPanelOpen):
		animationNode.play_backwards("panel_open")
	else:
		animationNode.play("panel_open")
	bSettingsPanelOpen = !bSettingsPanelOpen

func updatePanelColor(newColor : Color) -> void:
	if(!panelSettings):
		push_error("Panel not set!")
		return
	newColor *= G.bgColorMod
	newColor = newColor.clamp(Color(0.1,0.1,0.1,1),Color(1,1,1,1))
	panelSettings.self_modulate = newColor

func _on_color_picker_button_color_changed(color:Color) -> void:
	G.mainColor = color
