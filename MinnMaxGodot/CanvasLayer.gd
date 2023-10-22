extends CanvasLayer

var CUT_OFF = 160
var achUp = 0
var achDown = 160

var gc

# Child nodes set by _ready
var boxLeft
var boxRight
var achievementBox

var boxLeftLabel
var boxRightLabel
var achievementBoxTitle

var upTimer

# Set by nextLine
var index
var lines
var lineLength
var currentLine

# Set by showText
var targetLabel
var stepComplete

# Track key press
var keyPressActive = false

var symbolLookup = {
	",": true,
	".": true
}

func _ready():
	gc = get_tree().root.get_node("main")
	boxLeft = get_node("textBoxLeft")
	boxRight = get_node("textBoxRight")
	achievementBox = get_node("achievementBox")
	
	boxLeftLabel = get_node("textBoxLeft/Label")
	boxRightLabel = get_node("textBoxRight/Label")
	achievementBoxTitle = get_node("achievementBox/Label2")

	upTimer = get_node("achievementBox/upTimer")
	
	boxLeft.set_visible(false)
	boxRight.set_visible(false)
	# achievementBox.set_visible(false)

func showLeftBox(value):
	boxLeft.set_visible(value)
	boxRight.set_visible(!value)

func join(array, delimit):
	var i = 0
	var res = ""
	while i < array.size():
		var d = delimit if i < array.size() - 1 else ""
		var word = array[i]
		i += 1
		res += word + d
	return res

func makeLines(value):
	var words = value.split(" ")
	var wi = 0
	var tLines = []
	var line = []
	var count = 0
	while wi < words.size():
		var word = words[wi]
		wi += 1
		if count + word.length() + 3 >= CUT_OFF:
			var follow = ""
			if wi < words.size() - 1:
				follow = "..."
			tLines.append(join(line, " ") + follow)
			line.clear()
			count = 0
		line.append(word)
		count += word.length()
	if line.size() > 0:
		tLines.append(join(line, " "))
	return tLines

func showText(charName, value, _stepComplete):
	stepComplete = _stepComplete
	index = 0
	lines = makeLines(value)
	
	if charName == "leo" or charName == "ben":
		targetLabel = boxLeftLabel
		showLeftBox(true)
	elif charName == "janet":
		targetLabel = boxRightLabel
		showLeftBox(false)
	
	nextLine()

func noSpaces(line):
	var res = ""
	for c in line:
		if not (c == " "):
			res += c
	return res

func nextLine():
	if index >= lines.size():
		keyPressActive = false
		boxLeft.set_visible(false)
		boxRight.set_visible(false)
		stepComplete.call()
	else: 
		var line = lines[index]
		index += 1
		targetLabel.set_visible_characters(-1)
		targetLabel.set_text(line)
		keyPressActive = true

func achievementReady(audioClip):
	# Play audio here
	gc.playAudio(audioClip)
	upTimer.start()

func achTweenUp(audioClip):
	var tween = create_tween()
	tween.tween_property(achievementBox, "position", Vector2(0, achUp), 0.5)
	tween.tween_callback(func(): achievementReady(audioClip))

func achTweenDown():
	var tween = create_tween()
	tween.tween_property(achievementBox, "position", Vector2(0, achDown), 0.5)

func showAchievement(achName, audioClip):
	achievementBoxTitle.set_text(achName)
	achTweenUp(audioClip)

func _process(_delta):
	if keyPressActive:
		if Input.is_action_just_pressed("action"):
			nextLine()

func _on_up_timer_timeout():
	achTweenDown()
