extends Node2D

var gc
var tagsNode
@export var charName: String = ""

var slip = false
var facing = 0 # 0: up, 1: right, 2: down, 3: left
var facingLookup

func _ready():
	gc = get_tree().root.get_node("main")
	var curCell = currentCell()
	tagsNode = gc.getTagsNode()
	gc.setState(func(s): s[charName]["cell"] = curCell)
	gc.reportReady(charName)
	facingLookup = [
		Vector2(0, -1),
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0)
	]
	
func movingFalse(worldTarget):
	set_global_position(worldTarget)
	var state = gc.getState()
	var curCell = currentCell()
	if state["active_char"] == charName:
		tagsNode.triggerEvent(curCell)
		slip = gc.isIce(curCell)
	gc.setState(func(s): s[charName]["moving"] = false)

func move(targetCell):
	
	var curCell = currentCell()
	
	# Announce movement
	var state = gc.getState()
	if not state["seperate"] and state["active_char"] == charName:
		otherCharNode().listenForMovement(curCell)
	
	var tween = create_tween()
	var worldTarget = gc.cellToWorld(targetCell)
	tween.tween_property(self, "position", worldTarget, 0.2)
	tween.tween_callback(func(): movingFalse(worldTarget))
	
func listenForMovement(targetCell):
	gc.setState(func(s): s[charName]["cell"] = targetCell)

func currentCell():
	return gc.worldToCell(get_global_position())

func otherCharName():
	return "leo" if charName == "ben" else "ben"

func otherCharNode():
	return get_tree().root.get_node("main" + "/" + otherCharName())

func processSlip(charState):
	var fd = facingLookup[facing]
	gc.setState(func(s): s[charName]["cell"] = charState["cell"] + fd)

func _process(delta):
	
	print("_process(delta)")
	
	var state = gc.getState()
	var charState = state[charName]
	
	if state["ready"]:
		if (not charState["moving"]) and (not state["event"]):
			if state["active_char"] == charName: # and not state[otherCharName()]["moving"]

				if slip:
					slip = false
					processSlip(charState)

				else:

					if Input.is_action_pressed("up"):
						facing = 0
						
					elif Input.is_action_pressed("right"):
						facing = 1
					
					elif Input.is_action_pressed("down"):
						facing = 2
					
					elif Input.is_action_pressed("left"):
						facing = 3
						
					if Input.is_action_pressed("up"):
						var tc = charState["cell"] + Vector2(0, -1)
						if gc.inBounds(tc):
							gc.setState(func(s): s[charName]["cell"] = tc)
						
					elif Input.is_action_pressed("right"):
						var tc = charState["cell"] + Vector2(1, 0)
						if gc.inBounds(tc):
							print("right: ", delta)
							gc.setState(func(s): s[charName]["cell"] = tc)

					elif Input.is_action_pressed("down"):
						var tc = charState["cell"] + Vector2(0, 1)
						if gc.inBounds(tc):
							gc.setState(func(s): s[charName]["cell"] = tc)

					elif Input.is_action_pressed("left"):
						var tc = charState["cell"] + Vector2(-1, 0)
						if gc.inBounds(tc):
							gc.setState(func(s): s[charName]["cell"] = tc)

			var newCell = gc.getState()[charName]["cell"]
			var curCell = currentCell()
			if not (newCell.is_equal_approx(curCell)):
				gc.setState(func(s): s[charName]["moving"] = true)
				print("move(newCell)")
				move(newCell)
