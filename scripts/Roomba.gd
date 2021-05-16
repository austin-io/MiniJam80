extends KinematicBody

export (float) var SPEED = 2.0;

onready var ray = $RayCast;
onready var anim = $AnimatedSprite3D;

var health = 3;
var dir = Vector3();
var isBroken : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	
	anim.play("default");
	
	dir.x = (randf() * 2) - 1;
	dir.z = (randf() * 2) - 1;
	dir = dir.normalized();
	
	ray.cast_to = dir * SPEED;

func _process(delta):
	if(isBroken): return;
	
	$DirPoint.transform.origin = ray.cast_to;
	
	if(ray.is_colliding()):
		print("Turn!");
		bounce();

func bounce():
	dir = -dir;
	
	#dir = dir.normalized();
	ray.cast_to = dir * SPEED;

func _physics_process(delta):
	if(isBroken): return;
	
	move_and_slide(dir * SPEED, Vector3.UP);

func destroy():
	isBroken = true;
	$Area/CollisionShape.disabled = true;
	anim.play("broken");
	
func _on_Area_area_entered(area):
	if(isBroken): return;
	
	print("Roomba Ouch!");
	
	$StunParticles.emitting = true;
	
	health -= 1;
	if(health <= 0):
		destroy();
