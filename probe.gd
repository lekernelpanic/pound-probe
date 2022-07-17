extends RigidBody2D

var POWER = 40

func _physics_process(_delta):
	if Input.is_action_pressed("left"):
		apply_impulse(Vector2 (), Vector2(-POWER, 0))
	if Input.is_action_pressed("right"):
		apply_impulse(Vector2 (), Vector2(POWER, 0))
	if Input.is_action_pressed("up"):
		apply_impulse(Vector2 (), Vector2(0, -POWER))
	if Input.is_action_pressed("down"):
		apply_impulse(Vector2 (), Vector2(0, POWER))
