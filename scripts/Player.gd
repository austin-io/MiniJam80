extends KinematicBody

export (float) var MAX_SPEED = 10.0;
export (int) var health = 9;

onready var meowSFX = [
	preload("res://assets/music/Meow_01.wav"),
	preload("res://assets/music/Meow_02.wav"),
	preload("res://assets/music/Meow_03.wav"),
	preload("res://assets/music/Meow_04.wav"),
	preload("res://assets/music/Meow_05.wav")
];


onready var hairball = preload("res://scenes/Hairball.tscn");

onready var animSprite = $CanvasLayer/HUD/AnimatedSprite;
onready var audioPlayer = $AudioStreamPlayer3D;
onready var ray = $RayCast;
onready var pivot = $Pivot;
onready var cam = $Pivot/Camera;
onready var livesLabel = $CanvasLayer/HUD/HBoxContainer/CenterContainer4/Label;

var isGrounded : bool = false;

var canShoot : bool = true;
var canSwipe : bool = true;
var isVulnerable : bool = true;

const mouseSensitivity = 0.002;

var vel : Vector3 = Vector3.ZERO;
var targetVel = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
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
	
	# Melee Attack
	if(Input.is_action_just_pressed("attack") && canSwipe):
		print("Melee swipe attack!");
		canSwipe = false;
		
		animSprite.play("Swipe");
		
		playRandSound();
		
		$Pivot/Camera/Swipe/CollisionShape.disabled = false;
		#$Pivot/Camera/Swipe.visible = true;
		$SwipeTimer.start();
	
	# Range Attack
	if(Input.is_action_just_pressed("shoot") && canShoot):
		print("Hairball!");
		canShoot = false;
		
		playRandSound();
		
		$HairballCooldown.start();
		
		var h = hairball.instance();
		h.direction = -cam.global_transform.basis.z;
		add_child(h);
	
	#vel.x = lerp(vel.x, targetVel.x*MAX_SPEED, dt*10);
	#vel.z = lerp(vel.z, targetVel.y*MAX_SPEED, dt*10);

func _physics_process(delta):
	vel = move_and_slide(vel * MAX_SPEED, Vector3.UP);

func playRandSound():
	if(audioPlayer.get_playback_position() > 1.5 || !audioPlayer.playing):
			audioPlayer.stream = meowSFX[ randi() % meowSFX.size() ];
			audioPlayer.play();

func shootCooldown():
	canShoot = true;

func swipeTimeout():
	$Pivot/Camera/Swipe/CollisionShape.disabled = true;
	#$Pivot/Camera/Swipe.visible = false;
	$SwipeCooldown.start();

func swipeCooldown():
	canSwipe = true;
	animSprite.play("default");

func _on_Hurtbox_area_entered(area):
	if(!isVulnerable): return;
	
	print("Player hurt!");
	
	health -= 1;
	livesLabel.text = "Lives: " + str(health);
	isVulnerable = false;
	
	$InvincibilityTimer.start();

func _on_InvincibilityTimer_timeout():
	isVulnerable = true;
