extends KinematicBody

export (NodePath) onready var targetObj;
var target;
var direction: Vector3;
export (float) var SPEED = 2.0;
var stunned = false;

onready var stunTimer = $StunTimer;

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(targetObj);

func _physics_process(delta):
	if(stunned): return;
	
	direction = target.global_transform.origin - global_transform.origin;
	direction.y = 0;
	move_and_slide(direction.normalized() * SPEED, Vector3.UP);

func _on_Area_area_entered(area):
	if(stunned || !area.is_in_group("Swipe")):
		return;
	
	print("Stunned!");
	stunTimer.start();
	stunned = true;

func _on_StunTimer_timeout():
	stunned = false;
	
