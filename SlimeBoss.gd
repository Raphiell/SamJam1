extends "res://entity.gd"

var movetimer_length = 15
var movetimer = 0

func _ready():
	damage = 2
	move_speed = 30
	health = 15
	death_animation_scene = "res://BossDeath.tscn"

func _physics_process(delta):
	player_detection_loop()
	sprite_direction_loop()
	movement_loop()
	damage_loop()
	z_index_loop()
	if(player_detected):
		$anim.play("aggro")
		move_direction = get_parent().get_node("Player").global_transform.origin - global_transform.origin
	else:
		$anim.play("idle")
		move_direction = dir.CENTER