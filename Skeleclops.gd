extends "res://entity.gd"

var movetimer_length = 15
var movetimer = 0

func _ready():
	damage = 2
	detection_radius = 40
	move_speed = 40
	move_direction = dir.rand()
	$WalkTimer.start()
	max_health = 2
	health = max_health

func _physics_process(delta):
	player_detection_loop()
	sprite_direction_loop()
	if(player_detected):
		move_direction = get_parent().get_node("Player").global_transform.origin - global_transform.origin
		move_speed = 40
		animation_loop("aggro")
	else:
		move_speed = 10
		if(move_direction == dir.CENTER):
			animation_loop("idle")
		else:
			animation_loop("walk")
	movement_loop()
	damage_loop()
	z_index_loop()

func _on_WalkTimer_timeout():
	move_direction = dir.CENTER
	$WalkPauseTimer.start()

func _on_WalkPauseTimer_timeout():
	move_direction = dir.rand()
	$WalkTimer.start()
