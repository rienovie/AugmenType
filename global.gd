extends Node

signal colorUpdated(newColor : Color)

var mainColor : Color = Color(0,0.2,0.8,1):
	set(value):
		mainColor = value
		emit_signal("colorUpdated",value)

const bgColorMod : float = 0.5