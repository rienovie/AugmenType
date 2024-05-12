extends Node

@onready var input_node : LineEdit = $Input
@export var userLine_node : userPre
@export var cam_node : Camera2D
@export var feedLine_node : Label
@export var iMaxCharCount : int = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	feedLine_node.text = ""
	Dict.populateAllDicts()
	input_node.grab_focus()
	if(!userLine_node):
		push_error("UserLine node not defined!")
	if(!cam_node):
		push_error("Camera not defined!")

func feedWord(fromDict : String):
	if(!Dict.mDicts.has(fromDict)):
		push_error("Could not feed word from Dict: ",fromDict,"! Dict not found!")
		return
	var randWord : String = Dict.mDicts[fromDict].pick_random()
	feedLine_node.text = feedLine_node.text + randWord + " "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	updateCamLoc()
	if(feedLine_node.text.length() < iMaxCharCount):
		feedWord("three")
	pass

func updateCamLoc():
	cam_node.transform.origin = Vector2(userLine_node.size.x,0)

func _on_input_text_changed(new_text: String) -> void:
	if(new_text.length() == 0):
		return
	if(feedLine_node.text.begins_with(new_text)):
		userLine_node.addCorrect(new_text)
	else:
		userLine_node.addError(new_text,feedLine_node.text.left(1))
	feedLine_node.text = feedLine_node.text.right(-1)
	input_node.clear()


func _on_input_gui_input(event: InputEvent) -> void:
	if(userLine_node.iCount == 0):
		return
	if(event.is_action_pressed("Delete")):
		feedLine_node.text = userLine_node.deleteLast() + feedLine_node.text
