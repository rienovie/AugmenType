class_name score_ui

extends Control

@export var animPlayer : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !animPlayer:
		push_error("animPlayer not set in ScoreUI!")
		return
	animPlayer.play("fadeOut")
	print("Loaded!")
	pass # Replace with function body.

func testFunc() -> void:
	if !animPlayer:
		push_error("animPlayer not set in ScoreUI!")
		return
	animPlayer.play("fadeIn")	
	print("Func called!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
