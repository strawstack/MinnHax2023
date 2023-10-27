extends Node

@export var leoNode: Node2D
@export var benNode: Node2D
@export var tagsNode: Node2D
@export var canvasLayerNode: CanvasLayer
@export var canvasModulate: CanvasModulate
@export var eventAssetsNode: Node2D

var debug = true

var readyLookup = {
	"leo": false,
	"ben": false,
	"light": false
}

var state = {
	"ready": false,
	"event": false, # eventInProgress
	"active_char": "ben",
	"seperate": false,
	"leo": {
		"cell": Vector2(0, 0),
		"moving": false,
	},
	"ben": {
		"cell": Vector2(0, 0),
		"moving": false,
	}
}

var pauseTimerCallback # set by pause function from json

func fadeInComplete():
	setState(func(s): s["event"] = true)
	reportReady("light")
	var pathName = "res://events/start/data.json"
	tagsNode.callStartEvent(pathName)

func _ready():
	if debug:
		reportReady("light")
	else:
		canvasModulate.setBlack()
		canvasModulate.fadeIn(fadeInComplete)
	
	# Force correct visibility
	$CanvasLayer.set_visible(true)
	#$tags.set_visible(true)

func reportReady(key):
	readyLookup[key] = true
	for k in readyLookup:
		if not readyLookup[k]:
			return
	setState(func(s): s["ready"] = true)

func cellToWorld(cellVec):
	return cellVec * 32.0

func worldToCell(worldVec):
	return Vector2(floor(worldVec.x / 32.0), floor(worldVec.y / 32.0))

func hashCell(cell):
	return str(cell.x) + ":" + str(cell.y)

func getTagsNode():
	return tagsNode

func getCanvasLayer():
	return canvasLayerNode

func getEventArtNode():
	return eventAssetsNode

func getState():
	return state

func getLeoNode():
	return leoNode

func getBenNode():
	return benNode

func setState(userFunction):
	userFunction.call(getState())

func isIce(cell):
	return $ice.isIce(cell)

func inBounds(cell):
	return not $bounds.inBounds(cell)

func playAudio(audioClip):
	$audioStreams.get_node(audioClip).play()

func cameraRotate(value):
	$Camera2D.rotateCamera(value)

func moveCamera(to, speed, callback):
	var pos
	if to == "ben":
		pos = benNode.get_global_position()
	elif to == "leo":
		pos = leoNode.get_global_position()
	else:
		pos = $eventAssets.get_node(to).get_global_position()
	$Camera2D.moveCamera(pos, speed, callback)

func zoomCamera(to, speed, callback):
	$Camera2D.zoomCamera(to, speed, callback)

func cameraTrack(value):
	$Camera2D.cameraTrack(value)

func pause(value, callback):
	$pauseTimer.set_wait_time(value)
	pauseTimerCallback = callback
	$pauseTimer.start()

func seperate(value, callback):
	setState(func(s): s["seperate"] = value)
	callback.call()

func calcDiffTime(prev, target):
	return (target - prev).length() / 32 * 0.2

func charMoveComplete(charName, pos, callback):
	var cell = worldToCell(pos)
	setState(func(s): s[charName]["cell"] = cell)
	callback.call()

func move(charName, points, callback):
	var charNode = leoNode if charName == "leo" else benNode
	var tween = create_tween()
	var prevPos = charNode.get_global_position()
	for point in points:
		var targetPos = worldToCell($eventAssets.get_node(point).get_global_position()) * 32.0
		tween.tween_property(charNode, "position", targetPos, calcDiffTime(prevPos, targetPos))
		prevPos = targetPos
	tween.tween_callback(func(): charMoveComplete(charName, prevPos, callback))

func dimLight(callback):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(0.4, 0.4, 0.4), 2)
	tween.tween_callback(callback)

func raiseLight(callback):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color.WHITE, 2)
	tween.tween_callback(callback)

func dimToBlack(value, callback):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color.BLACK, value)
	tween.tween_callback(callback)

func backToStartComplete():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func backToStart(value):
	$pauseTimer.set_wait_time(value)
	pauseTimerCallback = backToStartComplete
	$pauseTimer.start()

func fireOn():
	$eventAssets.get_node("fireOn").set_visible(true)

func fireOff():
	$eventAssets.get_node("coals").set_visible(true)
	$eventAssets.get_node("fireOn").set_visible(false)

func _on_pause_timer_timeout():
	var temp = pauseTimerCallback
	pauseTimerCallback = null
	temp.call()
