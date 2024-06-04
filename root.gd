@tool
extends Node2D

@onready var this = get_node(".")

@export var parallaxSprite : Sprite2D

func _ready() -> void:
	G.connect("colorUpdated",modifyBackgroundColor)

func modifyBackgroundColor(newColor : Color) -> void:
	if(!parallaxSprite):
		push_error("Parallax Sprite not set in root!")
		return
	parallaxSprite.modulate = newColor
