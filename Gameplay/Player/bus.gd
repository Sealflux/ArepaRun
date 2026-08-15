extends RigidBody2D

var screen_size
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("bus")
	screen_size = get_viewport_rect().size
	await get_tree().create_timer(1.5).timeout
	self.queue_free()
	
	

func _physics_process(delta: float) -> void:
	pass
