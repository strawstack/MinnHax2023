extends Node2D

var gc
var tagLookup = {}
var canvasLayerNode

# Loaded by startEvent
var index
var steps

func _ready():
	gc = get_tree().root.get_node("main")
	canvasLayerNode = gc.getCanvasLayer()
	for child in get_children():
		var hashCell = gc.hashCell(gc.worldToCell(child.get_global_position()))
		tagLookup[hashCell] = child.name

func triggerEvent(cell):
	var hashCell = gc.hashCell(cell)
	if hashCell in tagLookup:
		gc.setState(func(s): s["event"] = true)
		var eventName = tagLookup[hashCell]
		var pathName = "res://events/" + eventName + "/data.json"
		var jsonString = readFile(pathName)
		var data = parseJSON(jsonString)
		startEvent(data.data)

func readFile(pathName):
	var file = FileAccess.open(pathName, FileAccess.READ)
	var content = file.get_as_text()
	return content

func parseJSON(jsonString):
	var json = JSON.new()
	var error = json.parse(jsonString)
	if error == OK: 
		return json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", jsonString, " at line ", json.get_error_line())

func startEvent(data):
	index = 0
	steps = data 
	nextStep()

func nextStep():
	if index >= steps.size():
		# Event complete!
		gc.setState(func(s): s["event"] = false)
	else:
		var step = steps[index]
		index += 1
		if step["type"] == "text":
			handleText(step["name"], step["value"])
		elif step["type"] == "achievement":
			handleAchievement(step["name"], step["value"])

func handleText(charName, value):
	canvasLayerNode.showText(charName, value, stepComplete)

func handleAchievement(achName, value):
	canvasLayerNode.showAchievement(achName, value)
	stepComplete()

func stepComplete():
	nextStep()

func _process(_delta):
	pass
