extends Camera2D

func _ready():
	$Area2D.connect("body_entered", self, "body_entered")
	$Area2D.connect("body_exited", self, "body_exited")

func _process(delta):
	var pos = get_node("../Player").global_position - Vector2(0, 16)
	var x = floor(pos.x / 160) * 160
	var y = floor(pos.y / 128) * 128
	global_position = pos - Vector2(80, 64)

func body_entered(body):
	if body.get("type") == "Enemy":
		body.set_physics_process(true)
	
func body_exited(body):
	if body.get("type") == "Enemy":
		body.set_physics_process(false)