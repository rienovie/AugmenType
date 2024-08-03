extends Node

@onready var input_node : LineEdit = $Input
@export var userLine_node : userPre
@export var cam_node : Camera2D
@export var feedLine_node : Label
@export var iMaxCharCount : int = 30
@export var iCamSpeed : int = 5
@export var scoreUI : score_ui

var bFinishedCurrentWord : bool = true :
	set(value):
		bFinishedCurrentWord = value
		G.bFinCurWord = value

var bTeleportCam : bool = false
var bStartedDelta : bool = false
var fCamDeltaAdd : float
var fCamDeltaTarget : float = 0.25

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

	cam_node.position_smoothing_speed = iCamSpeed

func feedWord():
	feedLine_node.text = feedLine_node.text + G.Dict.getRandomWord() + " "

func processScore(bThrowaway : bool = false) :
	bTeleportCam = true
	if(bThrowaway):
		userLine_node.calculateScore()
	else:
		G.addScore(userLine_node.calculateScore())
		scoreUI.testFunc()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateCamLoc(delta)
	if(feedLine_node.text.length() < iMaxCharCount):
		feedWord()

func updateCamLoc(delta : float):
	if(bTeleportCam):
		
		fCamDeltaAdd += delta
		print(fCamDeltaAdd) #debug to see how quick the value goes up
		
		if(!bStartedDelta):
			cam_node.position_smoothing_enabled = false
			cam_node.position_smoothing_speed = 100
			bStartedDelta = true
		elif(fCamDeltaAdd >= fCamDeltaTarget):
			cam_node.position_smoothing_speed = iCamSpeed
			cam_node.position_smoothing_enabled = true
			bTeleportCam = false
			bStartedDelta = false
		else:
			cam_node.position_smoothing_speed = lerp(100,iCamSpeed,fCamDeltaAdd/fCamDeltaTarget)

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
	G.inputGiven.emit()

func _on_input_gui_input(event: InputEvent) -> void:
	if(userLine_node.iCount == 0):
		return
	if(event.is_action_pressed("Delete")):
		feedLine_node.text = userLine_node.deleteLast() + feedLine_node.text
		setCurrentWordFinishedStatus()
		G.inputGiven.emit()
