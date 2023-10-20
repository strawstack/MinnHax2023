extends Node

var readyLookup = {
	"leo": false,
	"ben": false
}

var state = {
	"ready": false,
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

func _ready():
	pass

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

func getState():
	return state
	
func setState(userFunction):
	userFunction.call(getState())

func _process(delta):
	pass
