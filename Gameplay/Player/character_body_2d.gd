extends CharacterBody2D

@export var SPEED = 400
@export var JUMP_VELOCITY = -400.0
@export var rotation_speed = 2.0 # radians per second
@export var speed = 100.0
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	var turn = 1
	rotation += turn * rotation_speed * delta
	position.x += speed * delta   
