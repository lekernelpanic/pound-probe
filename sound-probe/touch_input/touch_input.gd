extends Sprite
# Manage touch and mouse input.


const APPARITION_SPEED = 0.25
const ALPHA = 0.2

var _initial_mouse_position


func _process(delta):
	var direction = Vector2(0, 0)
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		modulate.a += delta * APPARITION_SPEED
		
		var mouse_position = get_viewport().get_mouse_position()
		if _initial_mouse_position == Vector2(0, 0):
			_initial_mouse_position = mouse_position
			position = mouse_position
		else:
			direction = mouse_position - _initial_mouse_position
			rotation = direction.angle()
			direction = direction.normalized()
			direction = direction.snapped(Vector2(1, 1))
			_apply(direction)
	elif _initial_mouse_position != Vector2(0, 0):
		_stop()
		_initial_mouse_position = Vector2(0, 0)
	else:
		modulate.a -= delta * APPARITION_SPEED
	
	modulate.a = clamp(modulate.a, 0, ALPHA)


func _apply(direction):
	_stop()
	
	if direction.x == -1:
		Input.action_press("left")
	if direction.x == 1:
		Input.action_press("right")
	if direction.y == -1:
		Input.action_press("up")
	if direction.y == 1:
		Input.action_press("down")


func _stop():
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("up")
	Input.action_release("down")
