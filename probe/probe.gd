extends RigidBody2D

var POWER = 80

func _input(event):
	if event.is_action_pressed("left"):
		apply_impulse(Vector2 (), Vector2(-POWER, 0))
	if event.is_action_pressed("right"):
		apply_impulse(Vector2 (), Vector2(POWER, 0))
	if event.is_action_pressed("up"):
		apply_impulse(Vector2 (), Vector2(0, -POWER))
	if event.is_action_pressed("down"):
		apply_impulse(Vector2 (), Vector2(0, POWER))
