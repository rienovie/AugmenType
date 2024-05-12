@tool
extends Node

var dict : Array
var dict3 : Array

var mDicts : Dictionary = {
	"full" : dict ,
	"three" : dict3
}

func populateAllDicts():
	populateDict()
	populateDict3()

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

func populateDict3():
	if(dict.size() < 1):
		print("Dictionary not populated!")
		return
	
	dict3.clear()
	for word : String in dict:
		if(word.length() == 3):
			dict3.push_back(word)
