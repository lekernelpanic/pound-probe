extends Sprite2D
# Manage touch and mouse input.


const APPARITION_SPEED: float = 0.25
const ALPHA: float = 0.2

var _initial_mouse_position: Vector2


func _process(delta: float) -> void:
	var direction: Vector2 = Vector2(0, 0)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		modulate.a += delta * APPARITION_SPEED
		
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
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


func _apply(direction: Vector2) -> void:
	_stop()
	
	if direction.x == -1:
		Input.action_press("left")
	if direction.x == 1:
		Input.action_press("right")
	if direction.y == -1:
		Input.action_press("up")
	if direction.y == 1:
		Input.action_press("down")


func _stop() -> void:
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("up")
	Input.action_release("down")
