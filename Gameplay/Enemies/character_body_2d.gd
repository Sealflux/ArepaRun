extends CharacterBody2D

@export var speed: float = 125
var screen_size
var is_stunned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	position.y = -5
	if not is_stunned:
		velocity.x = speed
		speed = speed + 1
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collidedobject = collision.get_collider()
		
		if collidedobject.is_in_group("player"):
			collidedobject.queue_free()
			$"../../EspatulaUi".stopCooldown()
		elif collidedobject.is_in_group("destructible"):
			collidedobject.queue_free()
		elif collidedobject.is_in_group("bus"):
			stun(3)

func stun(duration: float) -> void:
	is_stunned = true
	velocity.x = 0
	await get_tree().create_timer(duration).timeout
	is_stunned = false
