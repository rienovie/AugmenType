extends Node

@onready var input_node : LineEdit = $Input
@export var userLine_node : Label
@export var cam_node : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_node.grab_focus()
	if(!userLine_node):
		push_error("UserLine node not defined!")
	if(!cam_node):
		push_error("Camera not defined!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_input_text_changed(new_text: String) -> void:
	if(new_text.length() == 0):
		return
	userLine_node.text = userLine_node.text + new_text
	input_node.clear()
	cam_node.transform.origin = Vector2(userLine_node.size.x + 25,0)


func _on_input_gui_input(event: InputEvent) -> void:
	if(userLine_node.text.length() == 0):
		return
	if(event.is_action_pressed("Delete")):
		userLine_node.text = userLine_node.text.left(-1)
		cam_node.transform.origin = Vector2(userLine_node.size.x - 25,0)
