extends Node
signal objectTotalChanged(num);
signal objectsRuinedChanged(num);
signal gameComplete;

var objectsLeft = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func registerObject():
	objectsLeft += 1;
	emit_signal("objectTotalChanged", objectsLeft);

func objectDestroyed():
	objectsLeft -= 1;
	emit_signal("objectsRuinedChanged", objectsLeft);
	checkComplete();

func checkComplete():
	if(objectsLeft <= 0):
		print("Complete");
		emit_signal("gameComplete");
