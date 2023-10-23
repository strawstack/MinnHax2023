extends TileMap

var gc
var boundsLookup = {}

func _ready():
	gc = get_tree().root.get_node("main")
	for tile in get_used_cells(0):
		var hashCell = gc.hashCell(Vector2(tile.x, tile.y))
		boundsLookup[hashCell] = true

func inBounds(cell):
	var hashCell = gc.hashCell(cell)
	return hashCell in boundsLookup
