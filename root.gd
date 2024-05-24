@tool
extends Node2D

@onready var this = get_node(".")

@export var parallaxSprite : Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	G.connect("colorUpdated",modifyBackgroundColor)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func modifyBackgroundColor(newColor : Color) -> void:
	if(!parallaxSprite):
		push_error("Parallax Sprite not set in root!")
		return
	parallaxSprite.modulate = newColor
