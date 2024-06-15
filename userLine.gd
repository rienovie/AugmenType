extends Node
class_name userPre

@export var root : HBoxContainer

var iCount : int = 0
var tUser = preload("res://scenes/user_template.tscn")
var tError = preload("res://scenes/error_template.tscn")

var mPrevious : Dictionary = {}

var currentUser : Control = null
var currentError : Control = null

func addCorrect(toAdd : String) -> void:
	currentUser.text = currentUser.text + toAdd
	iCount += 1

func addError(toAdd : String, expected : String) -> void:
	if(toAdd == " "):
		currentError.get_child(0).text = "_"
	else:
		currentError.get_child(0).text = toAdd
	currentError.get_child(1).text = expected
	iCount += 1
	
	addUserAndError()
	

func deleteLast() -> String:
	var output : String
	if(currentUser.text.length() == 0):
		if(mPrevious[currentError]):
			currentUser.queue_free()
			currentError.queue_free()
			currentUser = mPrevious[currentUser]
			currentError = mPrevious[currentError]
			output = currentError.get_child(1).text
			currentError.get_child(0).text = ""
			currentError.get_child(1).text = ""
			iCount -= 1
	else:
		output = currentUser.text.right(1)
		currentUser.text = currentUser.text.left(-1)
		iCount -= 1
	return output

func calculateScore() -> int :
	var scoreSum : int = 0
	var tempString : String = ""

	var bFirstDone : bool = false
	var contRef : Control = currentUser
	while(contRef):
		scoreSum += G.Dict.getWordCountFromString(contRef.text);
		contRef = mPrevious[contRef]
		if(!bFirstDone):
			if(!G.bFinCurWord):
				var nextChar : String = getLastChar(true)
				while(nextChar != " "):
					#TODO change to account for errors
					tempString = getLastChar(true) + tempString
					deleteLast()
					nextChar = getLastChar(true)
			bFirstDone = true
		currentUser.queue_free()
		currentUser = contRef
	
	contRef = currentError
	while(contRef):
		contRef = mPrevious[contRef]
		currentError.queue_free()
		currentError = contRef
		if(contRef):
			scoreSum -= G.errorPoints
	
	addUserAndError(true)
	currentUser.text = tempString
	iCount = tempString.length()

	# wpm conversion assumes 15 sec timer
	scoreSum *= 4

	return scoreSum

func getLastChar(bGetCorrect : bool = false) -> String:
	if(iCount == 0):
		return " "
	if(currentUser.text.length() == 0):
		if(bGetCorrect):
			return mPrevious[currentError].get_child(1).text[0]
		else:
			return mPrevious[currentError].get_child(0).text[0]
	else:
		return currentUser.text.right(1)

func addUserAndError(bInitialize : bool = false) -> void:
	if(bInitialize):
		for child in root.get_children():
			child.queue_free()
		mPrevious.clear()
		currentError = null
		currentUser = null
	
	var nUser = tUser.instantiate()
	root.add_child(nUser)
	mPrevious[nUser] = currentUser
	currentUser = nUser
	
	var nError = tError.instantiate()
	root.add_child(nError)
	mPrevious[nError] = currentError
	currentError = nError

func _ready() -> void:
	addUserAndError(true)
