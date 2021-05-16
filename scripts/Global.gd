extends Node

var objectsLeft = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func registerObject():
	objectsLeft += 1;

func objectDestroyed():
	objectsLeft -= 1;
