extends KinematicBody

var dir = Vector3();
export (float) var SPEED = 2.0;
onready var ray = $RayCast;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	
	dir.x = randf();
	dir.z = randf();
	dir = dir.normalized();
	
	ray.cast_to = dir * SPEED;

func _physics_process(delta):
	move_and_slide(dir * SPEED, Vector3.UP);
