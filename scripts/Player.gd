extends KinematicBody

var isGrounded : bool = false;
onready var ray = $RayCast;

const mouseSensitivity = 0.002;
onready var pivot = $Pivot;
onready var cam = $Pivot/Camera;

var vel : Vector3 = Vector3.ZERO;
var targetVel = Vector2.ZERO;
const MAX_SPEED = 10.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isGrounded = ray.is_colliding();
	getInput(delta);

func _input(event):
	if(event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		rotate_y(-event.relative.x * mouseSensitivity);
		pivot.rotate_x(-event.relative.y * mouseSensitivity);
		pivot.rotation.x = clamp(pivot.rotation.x, -1.5, 1.5);

func getInput(dt):
	#transform.basis.z
	targetVel.x = Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft");
	targetVel.y = Input.get_action_strength("backward") - Input.get_action_strength("forward");
	
	vel = transform.basis.z * targetVel.y;
	vel += transform.basis.x * targetVel.x;
	
	if(!isGrounded):
		vel.y -= 10;
	
	#vel.x = lerp(vel.x, targetVel.x*MAX_SPEED, dt*10);
	#vel.z = lerp(vel.z, targetVel.y*MAX_SPEED, dt*10);

func _physics_process(delta):
	vel = move_and_slide(vel * MAX_SPEED, Vector3.UP);
