@tool
extends Node2D

@onready var this = get_node(".")

@export_category("Main Dictionary")
@export var dictPop : bool = false :
	set(value):
		if(!this):
			return
		Dict.populateDict()
		reflectedDict = Dict.dict
@export var clearReflectedDict : bool = false :
	set(value):
		if(!this):
			return
		reflectedDict.clear()
@export var reflectedDict : Array

@export_category("Three Letter Dictionary")
@export var dict3Pop : bool = false :
	set(value):
		if(!this):
			return
		Dict.populateDict3()
		reflectedDict3 = Dict.dict3
@export var clearReflectedDict3 : bool = false :
	set(value):
		if(!this):
			return
		reflectedDict3.clear()
@export var reflectedDict3 : Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reflectedDict.clear()
	reflectedDict3.clear()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
