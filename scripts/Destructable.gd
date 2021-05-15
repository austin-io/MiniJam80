extends Area

export (int) var health = 1;
export (Texture) var sprite = null;

func _ready():
	if(sprite):
		$Sprite3D.texture = sprite;

func _on_Destructable_area_entered(area):
	print("Ouch!");
	health -= 1;
	if(health <= 0):
		destroy();

func destroy():
	print("Destroyed!");
	queue_free()
