@tool
extends Node

var dict : Array
var dict3 : Array

func populateDict():
	dict.clear()
	var sFile : String = FileAccess.get_file_as_string("res://resources/dict.txt")
	var sBuild : String = ""
	for char in sFile:
		if(char == "\n"):
			dict.push_back(sBuild)
			sBuild = ""
		else:
			sBuild = sBuild + char

func populateDict3():
	if(dict.size() < 1):
		print("Dictionary not populated!")
		return
	
	dict3.clear()
	for word : String in dict:
		if(word.length() == 3):
			dict3.push_back(word)
