extends CharacterBody2D

@export var speed: float = 125
@export var currentspeed: float
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("enemy")



func _physics_process(delta: float) -> void:
	position.x += speed * delta
	speed = speed + 0.2
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collidedobject = collision.get_collider()
		collidedobject.queue_free()

func stun(duration: float) -> void:
	currentspeed = speed
	speed = 0
	await get_tree().create_timer(duration).timeout
	speed = currentspeed
	
