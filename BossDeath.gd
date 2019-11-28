extends Node2D

func _ready():
	$anim.play("default")
	$anim.connect("animation_finished", self, "destroy")
	
func destroy(animation):
	var key = load("res://Key.tscn").instance()
	get_parent().add_child(key)
	key.position = position
	queue_free()