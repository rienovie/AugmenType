extends Node
class_name userPre

@export var root : HBoxContainer

var iCount : int = 0
var tUser = preload("res://scenes/user_template.tscn")
var tError = preload("res://scenes/error_template.tscn")

var mPrevious : Dictionary = {}

var currentUser : Control
var currentError : Control

func addCorrect(toAdd : String) -> void:
	currentUser.text = currentUser.text + toAdd
	iCount = iCount + 1

func addError(toAdd : String, expected : String) -> void:
	currentError.get_child(0).text = toAdd
	currentError.get_child(1).text = expected
	iCount = iCount + 1
	
	var nUser = tUser.instantiate()
	root.add_child(nUser)
	mPrevious[nUser] = currentUser
	currentUser = nUser
	
	var nError = tError.instantiate()
	root.add_child(nError)
	mPrevious[nError] = currentError
	currentError = nError
	

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
			iCount = iCount - 1
	else:
		output = currentUser.text.right(1)
		currentUser.text = currentUser.text.left(-1)
		iCount = iCount - 1
	return output

func calculateScore() -> int :
	#TODO
	return randi_range(20,50)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in root.get_children():
		child.queue_free()
	
	var newUser = tUser.instantiate()
	root.add_child(newUser)
	currentUser = newUser
	mPrevious[newUser] = null
	
	var newError = tError.instantiate()
	root.add_child(newError)
	currentError = newError
	mPrevious[newError] = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
