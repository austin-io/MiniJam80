extends KinematicBody

export (float) var SPEED = 10.0;
var direction = Vector3.FORWARD;
var timeout : Timer;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true);
	global_transform.origin += direction * 3;
	timeout = Timer.new();
	timeout.wait_time = 5;
	timeout.connect("timeout",self,"onTimeout");
	add_child(timeout);
	timeout.start();

func _physics_process(delta):
	move_and_slide(direction * SPEED, Vector3.UP);

func onTimeout():
	print("Timeout");
	destroy();

func _on_Area_body_entered(body):
	destroy();

func _on_Area_area_entered(area):
	destroy();

func destroy():
	print("Destroyed")
	queue_free();
