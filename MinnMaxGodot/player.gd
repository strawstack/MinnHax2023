extends Node2D

var gc
var tagsNode
@export var charName: String = ""

func _ready():
	gc = get_tree().root.get_node("main")
	var curCell = currentCell()
	tagsNode = gc.getTagsNode()
	gc.setState(func(s): s[charName]["cell"] = curCell)
	gc.reportReady(charName)
	
func movingFalse():
	var state = gc.getState()
	var curCell = currentCell()
	if state["active_char"] == charName:
		tagsNode.triggerEvent(curCell)
	gc.setState(func(s): s[charName]["moving"] = false)

func move(targetCell):
	
	var curCell = currentCell()
	
	var tween = create_tween()
	var worldTarget = gc.cellToWorld(targetCell)
	tween.tween_property(self, "position", worldTarget, 0.2)
	tween.tween_callback(movingFalse)
	
	# Announce movement
	var state = gc.getState()
	if not state["seperate"] and state["active_char"] == charName:
		otherCharNode().listenForMovement(curCell)

func listenForMovement(targetCell):
	gc.setState(func(s): s[charName]["cell"] = targetCell)

func currentCell():
	return gc.worldToCell(get_global_position())

func otherCharName():
	return "leo" if charName == "ben" else "ben"

func otherCharNode():
	return get_tree().root.get_node("main" + "/" + otherCharName())

func _process(_delta):
	
	var state = gc.getState()
	var charState = state[charName]
	
	if state["ready"]:
		if (not charState["moving"]) and (not state["event"]):
			if state["active_char"] == charName and not state[otherCharName()]["moving"]:
				if Input.is_action_pressed("up"):
					gc.setState(func(s): s[charName]["cell"] = charState["cell"] + Vector2(0, -1))
					
				elif Input.is_action_pressed("right"):
					gc.setState(func(s): s[charName]["cell"] = charState["cell"] + Vector2(1, 0))
					
				elif Input.is_action_pressed("down"):
					gc.setState(func(s): s[charName]["cell"] = charState["cell"] + Vector2(0, 1))
					
				elif Input.is_action_pressed("left"):
					gc.setState(func(s): s[charName]["cell"] = charState["cell"] + Vector2(-1, 0))

			var newCell = gc.getState()[charName]["cell"]
			var curCell = currentCell()
			if not (newCell.is_equal_approx(curCell)):
				gc.setState(func(s): s[charName]["moving"] = true)
				move(newCell)
