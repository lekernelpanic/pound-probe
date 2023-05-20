extends Control
# Draw the map for destinations, color changes when destinations are visited.


const SCALE: float = 0.004
const VALIDATION_DISTANCE: float = 5_000
const CIRCLE_COLOR: Color = Color(1, 1, 1, 0.2)
const PROBE_COLOR: Color = Color(1, 1, 1, 1)
const DESTIONATION_COLOR: Color = Color(0.5, 0.5, 0.5, 0.8)
const DESTIONATION_VISITED_COLOR: Color = Color(0.2, 1, 0.2, 0.8)

@export_node_path("Node2D") var probe: NodePath
@export var destinations: Array[NodePath]

var _center: Vector2
var _radius: float
var _is_destination_visited: Dictionary


func _init() -> void:
	_center = size / 2.0


func _ready():
	_radius = size.x / 2.0
	for destination in destinations:
		_is_destination_visited[destination] = false


func _process(_delta) -> void:
	for destination in destinations:
		var probe_pos: Vector2 = get_node(probe).position
		var destination_pos: Vector2 = get_node(destination).position
		
		if probe_pos.distance_to(destination_pos) <= VALIDATION_DISTANCE:
			_is_destination_visited[destination] = true
	
	queue_redraw()


func _draw() -> void:
	draw_arc(_center, _radius, 0, TAU, 64, CIRCLE_COLOR, 4, true)
	draw_circle(_center, 4, PROBE_COLOR)
	
	for destination in destinations:
		var probe_pos: Vector2 = get_node(probe).position
		var destination_pos: Vector2 = get_node(destination).position
		var draw_position: Vector2 = (destination_pos - probe_pos) * SCALE
		draw_position = _center + draw_position.limit_length(_radius)
		
		if _is_destination_visited[destination]:
			draw_circle(draw_position, 4, DESTIONATION_VISITED_COLOR)
		else:
			draw_circle(draw_position, 4, DESTIONATION_COLOR)
