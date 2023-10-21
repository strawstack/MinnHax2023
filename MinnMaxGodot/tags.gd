extends Node2D

var gc
var tagLookup = {}

func _ready():
	gc = get_tree().root.get_node("main")
	for child in get_children():
		var hashCell = gc.hashCell(gc.worldToCell(child.get_global_position()))
		tagLookup[hashCell] = child.name

func triggerEvent(cell):
	var hashCell = gc.hashCell(cell)
	if hashCell in tagLookup:
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
	for step in data:
		print(step)

func _process(delta):
	pass
