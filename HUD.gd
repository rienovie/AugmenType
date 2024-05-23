extends Node

@export var panelSettings : PanelContainer
@export var animationNode : AnimationPlayer

func _on_btn_settings_pressed() -> void:
	if(!panelSettings):
		print("Panel not set!")
		return
	if(!animationNode):
		print("Animation Node not set!")
		return
	animationNode.play("panel_open")
	print("Animation called!")
