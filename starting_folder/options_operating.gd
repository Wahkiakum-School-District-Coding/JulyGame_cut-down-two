extends Control

func _init():
	print("Hello from operating options menu")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://starting_folder/main_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_P):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://starting_folder/main_menu.tscn")

func _on_earth_pressed():
	print("Earth button pressed")

func _on_moon_pressed():
	print("Moon button pressed")

func _on_mars_pressed():
	print("Mars button pressed")

func _on_venus_pressed():
	print("Venus button pressed")

func _on_import_pressed():
	print("The Import your own Agent was button pressed")

func _on_mountain_pressed():
	print("Mountain button pressed")

func _on_wind_sheer_pressed():
	print("Wind Sheer button pressed")

func _on_launch_site_pressed():
	print("Launch Site Input button pressed")

func _on_target_site_pressed():
	print("Change the Target Site button pressed")

func _on_rocket_mass_pressed():
	print("Change the mass of the Rocket incluing payload button pressed")

func _on_run_menu_pressed():
	get_tree().change_scene_to_file("res://starting_folder/menu_play.tscn")

func _on_target_edit_text_submitted(new_text):
	var my_int = int(new_text)
	Global.landing_site.x = my_int

func _on_target_edit_z_text_submitted(new_text):
	Global.landing_site.z = int(new_text)
