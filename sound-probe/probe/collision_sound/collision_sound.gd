extends AudioStreamPlayer2D
# Sound on collisions


const MIN_COLLISION_DB = 10


func _on_probe_collision(force):
	if !playing:
		volume_db = min(force / 20, MIN_COLLISION_DB)
		volume_db -= MIN_COLLISION_DB
		play()
