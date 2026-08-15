extends CharacterBody2D

@export var speed = 125
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size



func _physics_process(delta: float) -> void:
	position.x += speed * delta
	var collision = move_and_collide(velocity * delta)   
	if collision: 
		var collided_object = collision.get_collider()
		collided_object.queue_free()
