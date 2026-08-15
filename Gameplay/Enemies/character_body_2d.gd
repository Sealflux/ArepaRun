extends CharacterBody2D

@export var speed = 125
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size



func _physics_process(delta: float) -> void:
	position.x += speed * delta
	speed = speed + 0.01
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collidedobject = collision.get_collider()
		collidedobject.queue_free()
