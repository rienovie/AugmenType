extends Node

@export var panelSettings : PanelContainer
@export var panelWPM : PanelContainer
@export var panelTimer : PanelContainer
@export var animationNode : AnimationPlayer
@export var colorPick : ColorPickerButton
@export var sldMinCount : Slider
@export var sldMaxCount : Slider
@export var chkBxDoubles : CheckButton
@export var comBxRestrictions : OptionButton
@export var lblAvgValue : Label
@export var lblLastValue : Label
@export var pBarTimer : ProgressBar
@export var mainTimer : Timer

var bSettingsPanelOpen : bool = false

func _ready() -> void:
	G.connect("colorUpdated",updatePanelColor)
	G.connect("score",updateScoreTxt)

	if(!colorPick):
		push_error("Color Picker not set in HUD!")
	else:
		var c = G.mainColor
		colorPick.color = c
	updatePanelColor(G.mainColor)
	if(!animationNode):
		push_error("Animation Node not set in HUD!")
	if(!colorPick):
		push_error("Color Picker not set in HUD!")
	if(!sldMinCount):
		push_error("Slider Min Count not set in HUD!")
	if(!sldMaxCount):
		push_error("Slider Max Count not set in HUD!")
	if(!chkBxDoubles):
		push_error("Check Box Doubles not set in HUD!")
	if(!comBxRestrictions):
		push_error("Combo Box Restrictions not set in HUD!")
	if(!lblAvgValue):
		push_error("Label Avg Value not set in HUD!")
	if(!lblLastValue):
		push_error("Label Last Value not set in HUD!")
	if(!pBarTimer):
		push_error("PBar Timer not set in HUD!")
	if(!mainTimer):
		push_error("Timer not set in HUD!")

	sldMinCount.value = DictCS.GetCurrentDictRange().x
	sldMaxCount.value = DictCS.GetCurrentDictRange().y
	comBxRestrictions.selected = DictCS.GetCurrentDictRestrict();
	chkBxDoubles.button_pressed = DictCS.GetCurrentDictDoubles();

	if(comBxRestrictions.selected != 0):
		chkBxDoubles.visible = false
	else:
		chkBxDoubles.visible = true
	
	mainTimer.start()
	mainTimer.connect("timeout",callTimerSignal)

func callTimerSignal() :
	G.scoreTimerCalled.emit()

func _process(_delta: float) -> void:
	pBarTimer.value = mainTimer.time_left

func _on_btn_settings_pressed() -> void:
	if(!panelSettings):
		push_error("Panel not set!")
		return
	if(!animationNode):
		push_error("Animation Node not set!")
		return
	if(bSettingsPanelOpen):
		animationNode.play_backwards("panel_open")
	else:
		animationNode.play("panel_open")
	bSettingsPanelOpen = !bSettingsPanelOpen

func updatePanelColor(newColor : Color) -> void:
	if(!panelSettings):
		push_error("Panel Settings not set in HUD!")
		return
	if(!panelWPM):
		push_error("Panel WPM not set in HUD!")
		return
	if(!panelTimer):
		push_error("Panel Timer not set in HUD!")
		return
	newColor *= G.bgColorMod
	newColor = newColor.clamp(Color(0.1,0.1,0.1,1),Color(1,1,1,1))
	panelSettings.self_modulate = newColor
	panelWPM.self_modulate = newColor
	panelTimer.self_modulate = newColor
	
	newColor = newColor.clamp(Color(0.15,0.15,0.15,0.6),Color(1,1,1,0.6))
	var stylebox = pBarTimer.get("theme_override_styles/fill")
	stylebox.bg_color = newColor

func _on_color_picker_button_color_changed(color:Color) -> void:
	G.mainColor = color

func updateScoreTxt(value : int):
	lblLastValue.text = str(value)
	var avg : float = 0.0
	for i in G.scores:
		avg += i
	lblAvgValue.text = str(roundi(avg / G.scores.size()))

func updateDict():
	DictCS.BuildGameDict(Vector2(sldMinCount.value,sldMaxCount.value),
		comBxRestrictions.selected,chkBxDoubles.button_pressed)

func _on_sld_min_count_drag_ended(value_changed:bool) -> void:
	if(!value_changed):
		return
	if(sldMaxCount.value < sldMinCount.value):
		sldMaxCount.value = sldMinCount.value
	updateDict()


func _on_sld_max_count_drag_ended(value_changed:bool) -> void:
	if(!value_changed):
		return
	if(sldMinCount.value > sldMaxCount.value):
		sldMinCount.value = sldMaxCount.value
	updateDict()


func _on_chk_bx_doubles_toggled(_toggled_on:bool) -> void:
	updateDict()


func _on_com_bx_restrictions_item_selected(index:int) -> void:
	if(index != 0):
		chkBxDoubles.visible = false
	else:
		chkBxDoubles.visible = true
	updateDict()


func _on_btn_default_color_pressed() -> void:
	G.mainColor = Color(0.0,0.6,0.8,1)
	colorPick.color = G.mainColor
