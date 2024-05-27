extends Node

signal colorUpdated(newColor : Color)
signal score(value : int)
signal scoreTimerCalled()

var mainColor : Color = Color(0,0.6,0.8,1):
	set(value):
		mainColor = value
		emit_signal("colorUpdated",value)

const bgColorMod : float = 0.5

var scores : Array

var bFin : bool

func addScore(scoreToAdd : int):
	scores.push_back(scoreToAdd)
	emit_signal("score",scoreToAdd)
