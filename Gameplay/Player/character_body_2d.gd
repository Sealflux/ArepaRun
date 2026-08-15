extends CharacterBody2D

@export var SPEED = 400
@export var JUMP_VELOCITY = -400.0
@export var rotation_speed = 6.0 # radians per second
@export var momentum = 100.0
# Active Ability - Spatula
@export var Espatula: PackedScene
var can_spawnEspatula: bool = true
# Active Ability - Bus
@export var Bus: PackedScene
var can_spawnBus: bool = true
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("player")
	Espatula = preload("res://Gameplay/Player/espatula.tscn")
	Bus = preload("res://Gameplay/Player/bus.tscn")

func launch(x_power: float, y_power: float) -> void:
	momentum = momentum + x_power
	velocity.y = y_power

func turnfunc(delta) -> void:
	var turn = 1
	rotation += turn * rotation_speed * delta

func speedadjust(x_power: float) -> void:
	momentum = momentum + x_power

func spawn_spatula_in_front() -> void:
	if Espatula == null:
		print("ERROR: No Spatula scene assigned in the Inspector!")
		return
	# Create the new spatula
	var new_spatula = Espatula.instantiate()

	new_spatula.global_position = global_position + Vector2(150, 0)
	get_tree().current_scene.add_child(new_spatula)

	can_spawnEspatula = false
	await get_tree().create_timer(3).timeout
	can_spawnEspatula = true
func spawn_bus_behind_you() -> void:
	if Bus == null:
		print("ERROR: No Bus scene assigned in the Inspector!")
		return
	var new_bus = Bus.instantiate()
	new_bus.global_position = global_position + Vector2(-150, -600)
	get_tree().current_scene.add_child(new_bus)
	can_spawnBus = false
	await get_tree().create_timer(3).timeout
	can_spawnBus = true
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
	turnfunc(delta)
	position.x += momentum * delta   
	if Input.is_action_just_pressed("spawn_espatula") and can_spawnEspatula:
		spawn_spatula_in_front()
	if Input.is_action_just_pressed("spawn_bus") and can_spawnBus:
		spawn_bus_behind_you()
