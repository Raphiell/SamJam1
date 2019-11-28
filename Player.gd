extends "res://entity.gd"

var screen_size
var state = "default"
var death_screen_timer = 100
export var player_health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	type = "Player"
	set_physics_process(true)
	damage = 0
	get_node("hitSound").stream = load("res://sound/hit2.wav")
	health = player_health

func _physics_process(delta):
	if health > 0:
		match state:
			"default":
				state_default()
			"swing":
				state_swing()
	elif health <= 0:
		state_dead()
	
func state_swing():
	animation_loop("swing")
	damage_loop()
	movement_loop()
	move_direction = dir.CENTER
	z_index_loop()
	
func state_default():
	controls_loop()
	movement_loop()
	sprite_direction_loop()
	damage_loop()
	z_index_loop()
	
	if is_on_wall() and move_direction != dir.CENTER:
		if sprite_direction == "left" and test_move(transform, dir.LEFT):
			animation_loop("push")
		if sprite_direction == "right" and test_move(transform, dir.RIGHT):
			animation_loop("push")
		if sprite_direction == "up" and test_move(transform, dir.UP):
			animation_loop("push")
		if sprite_direction == "down" and test_move(transform, dir.DOWN):
			animation_loop("push")
	elif move_direction != dir.CENTER:
		animation_loop("walk")
	elif health <= 0:
		$anim.play("dead")
	else:
		animation_loop("idle")
		
	if(Input.is_action_just_pressed("a")):
		use_item(preload("res://Sword.tscn"))
		$SwordSwing.play(0)

func state_dead():
	move_direction = dir.CENTER
	movement_loop()
	$anim.play("dead")
	if death_screen_timer > 0:
		death_screen_timer -= 1
	elif death_screen_timer == 0:
		death_screen_timer = -100 # So the below only happens once
		var deathScreen = preload("res://DeathScreen.tscn").instance()
		get_parent().add_child(deathScreen)
		deathScreen.set("global_position", get_parent().get_node("camera").global_position)
		deathScreen.get_node("anim").play("fadein")

func controls_loop():
	# Movement
	move_direction.x = int(Input.is_action_pressed("ui_right")) + -int(Input.is_action_pressed("ui_left"))
	move_direction.y = int(Input.is_action_pressed("ui_down")) + -int(Input.is_action_pressed("ui_up"))

func _on_TimerToFadeout_timeout():
	pass
