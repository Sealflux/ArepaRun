extends Area2D

var screen_size
@export var launch_power_x: float = 125
@export var launch_power_y: float = -1000
@export var qte_scene: PackedScene  

var qte_instance = null
var player_ref = null
var enemy_ref = null
var is_qte_running = false
var was_player_moving = false
var was_enemy_moving = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	body_entered.connect(_on_body_entered)
	qte_scene = preload("res://Gameplay/Player/qte.tscn")

func _on_body_entered(body: Node) -> void:
	print(body)
	print("entered")
	if body.is_in_group("player") and not is_qte_running and player_ref == null:
		player_ref = body
		# Find the enemy (assuming it's in the scene)
		enemy_ref = get_tree().get_first_node_in_group("enemy")
		start_qte()

func start_qte() -> void:
	if qte_scene and not is_qte_running:
		is_qte_running = true
		
		# Pause everything before QTE
		pause_game_for_qte()
		
		# Create and setup QTE
		qte_instance = qte_scene.instantiate()
		var current_scene = get_tree().current_scene
		current_scene.add_child(qte_instance)
		
		qte_instance.position.x = player_ref.position.x
		
		# Connect the completion signal
		qte_instance.qte_completed.connect(_on_qte_completed)
		
		# Start the QTE
		qte_instance.start_qte()

func pause_game_for_qte() -> void:
	# Pause player
	if player_ref and player_ref.has_method("set_paused"):
		player_ref.set_paused(true)
	elif player_ref and player_ref.has_method("set_process"):
		player_ref.set_process(false)
		player_ref.set_physics_process(false)
	
	# Pause enemy
	if enemy_ref:
		if enemy_ref.has_method("set_paused"):
			enemy_ref.set_paused(true)
		elif enemy_ref.has_method("set_process"):
			enemy_ref.set_process(false)
			enemy_ref.set_physics_process(false)
func resume_game_after_qte() -> void:
	# Resume player
	if player_ref:
		if player_ref.has_method("set_paused"):
			player_ref.set_paused(false)
		elif player_ref.has_method("set_process"):
			player_ref.set_process(true)
			player_ref.set_physics_process(true)
	
	# Resume enemy
	if enemy_ref:
		if enemy_ref.has_method("set_paused"):
			enemy_ref.set_paused(false)
		elif enemy_ref.has_method("set_process"):
			enemy_ref.set_process(true)
			enemy_ref.set_physics_process(true)
	
func _on_qte_completed(success: bool) -> void:
	is_qte_running = false
	
	# Resume game first
	resume_game_after_qte()
	
	if success:
		print("QTE Success! Launching player...")
		if player_ref and player_ref.has_method("launch"):
			player_ref.launch(launch_power_x, launch_power_y)
		
		# Play spatula animation and destroy
		self.get_parent().play_anim("Espatula")
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
	else:
		print("QTE Failed!")
		if player_ref and player_ref.has_method("launch"):
			player_ref.launch(10, 60)
		# Still destroy the spatula
		self.get_parent().play_anim("Espatula")
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
	
	# Clean up QTE if it hasn't been freed yet
	if qte_instance and is_instance_valid(qte_instance):
		qte_instance.queue_free()
		qte_instance = null
	
	player_ref = null
	enemy_ref = null
