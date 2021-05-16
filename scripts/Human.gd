extends KinematicBody

export (NodePath) onready var targetObj;
export (float) var SPEED = 2.0;

onready var stunTimer = $StunTimer;
onready var anim = $AnimatedSprite3D;

var target;
var direction: Vector3;
var stunned = false;
var hasHat = true;
var hatDestroyed = false;
var hatHealth = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(targetObj);
	anim.play("WalkHat");
	Global.registerObject();

func _physics_process(delta):
	if(stunned): return;
	
	direction = target.global_transform.origin - global_transform.origin;
	direction.y = 0;
	move_and_slide(direction.normalized() * SPEED, Vector3.UP);

func _on_Area_area_entered(area):
	if(stunned || !area.is_in_group("Swipe")):
		return;
	
	print("Stunned!");
	
	hasHat = hatHealth > 0;
	
	if(hasHat):
		hatHealth -= 1;
		anim.play("IdleHat");
	else:
		if(!hatDestroyed):
			hatDestroyed = true;
			Global.objectDestroyed();
		anim.play("Idle");

	$StunParticles.emitting = true;
	stunTimer.start();
	stunned = true;

func _on_StunTimer_timeout():
	stunned = false;
	anim.play("WalkHat" if hasHat else "Walk");
