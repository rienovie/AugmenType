extends Node

@onready var input_node : LineEdit = $Input
@export var userLine_node : userPre
@export var cam_node : Camera2D
@export var feedLine_node : Label
@export var iMaxCharCount : int = 30
@export var bFinishedCurrentWord : bool = true :
	set(value):
		bFinishedCurrentWord = value
		G.bFinCurWord = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	G.scoreTimerCalled.connect(processScore)
	feedLine_node.text = ""
	input_node.grab_focus()
	
	G.Dict.buildGameDict(G.Dict.Alternating,Vector2i(3,6),false)
	
	if(!userLine_node):
		push_error("UserLine node not defined!")
	if(!cam_node):
		push_error("Camera not defined!")

func feedWord():
	feedLine_node.text = feedLine_node.text + G.Dict.getRandomWord() + " "

func processScore():
	G.addScore(userLine_node.calculateScore())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	updateCamLoc()
	if(feedLine_node.text.length() < iMaxCharCount):
		feedWord()

func updateCamLoc():
	cam_node.transform.origin = Vector2(userLine_node.size.x,0)

func setCurrentWordFinishedStatus():
	if(userLine_node.getLastChar() == ' '
	|| userLine_node.getLastChar(true) == '_'
	|| feedLine_node.text[0] == ' '):
		bFinishedCurrentWord = true
	else:
		bFinishedCurrentWord = false

func _on_input_text_changed(new_text: String) -> void:
	if(new_text.length() == 0):
		return
	#TODO this just removes any extra, should instead queue it
	if(new_text.length() > 1):
		new_text = new_text[0]
	if(G.Dict.isValidChar(new_text)):
		input_node.clear()
		return
	if(feedLine_node.text.begins_with(new_text)):
		userLine_node.addCorrect(new_text)
	else:
		userLine_node.addError(new_text,feedLine_node.text.left(1))
	feedLine_node.text = feedLine_node.text.right(-1)
	input_node.clear()
	setCurrentWordFinishedStatus()

func _on_input_gui_input(event: InputEvent) -> void:
	if(userLine_node.iCount == 0):
		return
	if(event.is_action_pressed("Delete")):
		feedLine_node.text = userLine_node.deleteLast() + feedLine_node.text
		setCurrentWordFinishedStatus()
