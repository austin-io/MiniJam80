extends KinematicBody

export (NodePath) onready var targetObj;
var target;
var direction: Vector3;
var SPEED = 2.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(targetObj);

func _physics_process(delta):
	direction = target.global_transform.origin - global_transform.origin;
	direction.y = 0;
	move_and_slide(direction.normalized() * SPEED, Vector3.UP);
