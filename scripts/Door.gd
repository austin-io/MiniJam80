extends Area

func _ready():
	Global.connect("gameComplete", self, "activateGoal")

func activateGoal():
	$AnimatedSprite3D.play("complete");
	$CollisionShape.disabled = false;


func _on_Door_body_entered(body):
	print("Next Scene");
	get_tree().change_scene("res://scenes/Credits.tscn");
