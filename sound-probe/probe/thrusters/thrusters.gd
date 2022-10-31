extends Node2D
# Particles and sound of thrusters.


func _process(_delta):
	var thrusters = false
	
	$particles/left.emitting = false
	$particles/right.emitting = false
	$particles/up.emitting = false
	$particles/down.emitting = false
	
	if Input.is_action_pressed("left"):
		$particles/right.emitting = true
		thrusters = true
	if Input.is_action_pressed("right"):
		$particles/left.emitting = true
		thrusters = true
	if Input.is_action_pressed("up"):
		$particles/down.emitting = true
		thrusters = true
	if Input.is_action_pressed("down"):
		$particles/up.emitting = true
		thrusters = true
	
	if thrusters:
		if !$audio_stream_player.playing:
				$audio_stream_player.play()
	else:
		$audio_stream_player.stop()
