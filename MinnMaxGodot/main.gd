extends Node

@export var leoNode: Node2D
@export var benNode: Node2D
@export var tagsNode: Node2D
@export var canvasLayerNode: CanvasLayer
@export var canvasModulate: CanvasModulate
@export var eventArtNode: Node2D

var readyLookup = {
	"leo": false,
	"ben": false,
	"light": false
}

var state = {
	"ready": false,
	"event": false, # eventInProgress
	"active_char": "ben",
	"leo": {
		"cell": Vector2(0, 0),
		"moving": false,
	},
	"ben": {
		"cell": Vector2(0, 0),
		"moving": false,
	}
}

func fadeInComplete():
	setState(func(s): s["event"] = true)
	reportReady("light")
	var pathName = "res://events/start/data.json"
	tagsNode.callStartEvent(pathName)

func _ready():
	var debug = true
	if debug:
		reportReady("light")
	else:
		canvasModulate.fadeIn(fadeInComplete)

func reportReady(key):
	readyLookup[key] = true
	for k in readyLookup:
		if not readyLookup[k]:
			return
	setState(func(s): s["ready"] = true)

func cellToWorld(cellVec):
	return cellVec * Vector2(32.0, 32.0)

func worldToCell(worldVec):
	return Vector2(floor(worldVec.x / 32.0), floor(worldVec.y / 32.0))

func hashCell(cell):
	return str(cell.x) + ":" + str(cell.y)

func getTagsNode():
	return tagsNode

func getCanvasLayer():
	return canvasLayerNode

func getEventArtNode():
	return eventArtNode

func getState():
	return state

func getLeoNode():
	return leoNode

func getBenNode():
	return benNode

func setState(userFunction):
	userFunction.call(getState())

func playAudio(audioClip):
	$audioStreams.get_node(audioClip).play()

func cameraRotate(value):
	$Camera2D.rotateCamera(value)

func _process(_delta):
	pass
