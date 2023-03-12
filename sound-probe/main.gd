extends Node2D
# General to the game.


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		if get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_window().mode = Window.MODE_WINDOWED
		else:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	
	
	if event.is_action_pressed("exit"):
		$exit_timer.start()
		$ui/exit.visible = true

	if event.is_action_released("exit"):
		$exit_timer.stop()
		$ui/exit.visible = false


func _on_exit_timer_timeout():
	get_tree().quit()
