extends KinematicBody2D

var type = "Enemy"
var damage = 0

var move_direction = dir.CENTER
var sprite_direction = "down"
export var move_speed = 0
export var knockback_force = 150
export var knockback_duration = 10
export var hitstun_duration = 20
export var detection_radius = 50
var player_detected = false
var texture_default = null
var texture_hurt = null
var directions = [dir.UP, dir.LEFT, dir.DOWN, dir.RIGHT]
var keycount = 0

var death_animation_scene = "res://EnemyDeath.tscn"

var knock_direction = dir.CENTER
var knockback = 0
var hitstun = 0
var hit_sound = "res://sound/hit.wav"

var max_health = 2
var health = max_health

func _ready():
	texture_default = $Sprite.texture
	texture_hurt = load($Sprite.texture.get_path().replace(".png", "_hurt.png"))
	var audio_stream = AudioStreamPlayer2D.new()
	audio_stream.stream = load(hit_sound)
	audio_stream.set_name("hitSound")
	audio_stream.volume_db = -10
	add_child(audio_stream)
	
func player_detection_loop():
	if(global_position.distance_to(get_parent().get_node("Player").global_position) < detection_radius):
		player_detected = true
	else:
		player_detected = false

func z_index_loop():
	z_index = position.y

func movement_loop():
	var motion
	if knockback > 0:
		knockback -= 1
	if knockback == 0:
		motion = move_direction.normalized() * move_speed
	else:
		motion = knock_direction.normalized() * knockback_force
	move_and_slide(motion, dir.CENTER)
	
func sprite_direction_loop():
	var new_direction = dir.CENTER
	for direction in directions:
		if(move_direction.dot(direction) > move_direction.dot(new_direction)):
			new_direction = direction
	match new_direction:
		dir.LEFT:
			sprite_direction = "left"
		dir.RIGHT:
			sprite_direction = "right"
		dir.UP:
			sprite_direction = "up"
		dir.DOWN:
			sprite_direction = "down"

func animation_loop(animation):
	var new_animation = str(animation, sprite_direction)
	if $anim.current_animation != new_animation:
		$anim.play(new_animation)

func damage_loop():
	if hitstun > 0:
		hitstun -= 1
		$Sprite.texture = texture_hurt
	if knockback == 0:
		if hitstun == 0:
			$Sprite.texture = texture_default
		if type == "Enemy" and health <= 0:
			var death_animation = load(death_animation_scene).instance()
			get_parent().add_child(death_animation)
			death_animation.position = position
			queue_free()
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if(hitstun == 0 and body.get("damage") != 0 and body.get("damage") != null and body.get("type") != type):
			health -= body.get("damage")
			hitstun = hitstun_duration
			knockback = knockback_duration
			knock_direction = global_transform.origin - body.global_transform.origin
			get_node("hitSound").play(0)
		if(body.get("type") == "Door"):
			if(keycount > 0):
				body.queue_free()
				keycount -= 1
				var doorSound = AudioStreamPlayer2D.new()
				doorSound.stream = load("res://sound/door.wav")
				doorSound.volume_db = -10
				get_parent().add_child(doorSound)
				doorSound.play(0)
		if(body.get("type") == "Key" and type == "Player"):
			body.queue_free()
			keycount += 1
			var keySound = AudioStreamPlayer2D.new()
			keySound.stream = load("res://sound/key.wav")
			keySound.volume_db = -10
			get_parent().add_child(keySound)
			keySound.play(0)
		
func use_item(item):
	var newitem = item.instance()
	newitem.add_to_group(str(newitem.get_name(), self))
	add_child(newitem)
	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
		newitem.queue_free()
		