extends Sprite

func _on_Button_button_down():
	$anim.play("fadeout")


func _on_anim_animation_finished(anim_name):
	if anim_name == "fadeout":
		get_tree().reload_current_scene()
