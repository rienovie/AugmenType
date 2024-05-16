@tool
extends Node

var dict : Array

# flag: countRange (min, max[9]) ex (3,5) = 3,4,& 5 / ex (7,9) = 7,8,& large
var dict3 : Array
var dict4 : Array
var dict5 : Array
var dict6 : Array
var dict7 : Array
var dict8 : Array
var dictLarge : Array # value of 9 in flags

var dictBuilt : Array # use this for the game

func _ready() -> void:
	populateAllDicts()

func buildDict(flags : dictFlags) :
	dictBuilt.clear()
	
	dictBuilt = dict3 + dict4 + dict5 + dict6 + dict7

func populateAllDicts():
	populateDict()
	
	dict3.clear()
	dict3 = dictCountFilter(3)
	dict4.clear()
	dict4 = dictCountFilter(4)
	dict5.clear()
	dict5 = dictCountFilter(5)
	dict6.clear()
	dict6 = dictCountFilter(6)
	dict7.clear()
	dict7 = dictCountFilter(7)
	dict8.clear()
	dict8 = dictCountFilter(8)
	dictLarge.clear()
	dictLarge = dictCountFilter(9)

func populateDict():
	dict.clear()
	var sFile : String = FileAccess.get_file_as_string("res://resources/dict.txt")
	var sBuild : String = ""
	for c in sFile:
		if(c == "\n"):
			dict.push_back(sBuild)
			sBuild = ""
		else:
			sBuild = sBuild + c

func dictCountFilter(count : int) -> Array :
	return dict.filter(
		func(string):
			if(count >= 9):
				return string.length() >= 9
			else:
				return string.length() == count
	)
