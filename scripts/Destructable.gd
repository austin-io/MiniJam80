extends Area

export (int) var health = 1;
export (Texture) var sprite = null;
export (SpriteFrames) var spriteFrames;

onready var anim = $AnimatedSprite3D;

var isBroken : bool = false;

func _ready():
	Global.registerObject();
	
	if(sprite):
		$Sprite3D.texture = sprite;
	
	if(spriteFrames):
		anim.frames = spriteFrames;
		anim.play("default");
	

func _on_Destructable_area_entered(area):
	if(isBroken): return;
	
	print("Ouch!");
	$StunParticles.emitting = true;
	health -= 1;
	if(health <= 0):
		destroy();

func destroy():
	print("Destroyed!");
	$StunParticles.emitting = true;
	anim.play("broken");
	#queue_free();
