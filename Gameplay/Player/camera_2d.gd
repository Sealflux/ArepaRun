extends Camera2D

@export var speed := 100  # Pixels per second

func _process(delta: float) -> void:
	position.x += speed * delta   
