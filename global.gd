extends Node

signal colorUpdated(newColor : Color)
signal score(value : int)
signal scoreTimerCalled()

var Dict = AugmenDict.new()

var mainColor : Color = Color(0,0.6,0.8,1):
	set(value):
		mainColor = value
		emit_signal("colorUpdated",value)
		Dict.AugTestPrint("Hi")
		print(Dict.isValidChar('g'))
		print(Dict.isValidChar('$'))

const bgColorMod : float = 0.5

var scores : Array
var errorPoints : int = 5
var bFinCurWord : bool = true

func addScore(scoreToAdd : int):
	scores.push_back(scoreToAdd)
	emit_signal("score",scoreToAdd)
	
