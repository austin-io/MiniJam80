extends KinematicBody

var dir = Vector3();
export (float) var SPEED = 2.0;
onready var ray = $RayCast;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	
	dir.x = (randf() * 2) - 1;
	dir.z = (randf() * 2) - 1;
	dir = dir.normalized();
	
	ray.cast_to = dir * SPEED;

func _process(delta):
	$DirPoint.transform.origin = ray.cast_to;
	
	if(ray.is_colliding()):
		print("Turn!");
		bounce();

func bounce():
	dir = -dir;
	
	#dir = dir.normalized();
	ray.cast_to = dir * SPEED;

func _physics_process(delta):
	move_and_slide(dir * SPEED, Vector3.UP);
