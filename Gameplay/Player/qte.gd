extends Node2D

signal qte_completed(success: bool)

@onready var animated_sprite = $AnimatedSprite2D
@onready var qte_button = $Button
@onready var label = $Label

var is_qte_active: bool = false
var qte_success: bool = false
var qte_failed: bool = false
var has_emitted_result: bool = false
var input_window_timer: SceneTreeTimer = null
@export var qte_input_action: String = "qte_action"
func _ready():
	# Connect button signal
	qte_button.pressed.connect(_on_qte_button_pressed)
	
	# Connect animation signals
	animated_sprite.frame_changed.connect(_on_frame_changed)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	
	# Hide initially
	visible = false

func start_qte():
	visible = true
	is_qte_active = true
	qte_success = false
	qte_failed = false
	has_emitted_result = false
	
	# Play the QTE animation
	animated_sprite.play("QTE")
	label.text = "QTE Started! Press button on the right frame!"
	
	# Bring to front
	if get_parent():
		get_parent().move_child(self, -1)

func _on_frame_changed():
	if not is_qte_active:
		return
	
	var current_frame = animated_sprite.frame
	var animation = animated_sprite.animation
	
	# Check if we're on the "hit window" frame
	if animation == "QTE" and current_frame == 3:  # Frame 3 = hit window
		label.text = "PRESS NOW! (Frame 3)"
		
		# Cancel any existing timer
		if input_window_timer:
			input_window_timer = null
		
		# Create a timer for the input window
		input_window_timer = get_tree().create_timer(0.2)
		await input_window_timer.timeout
		
		# If player didn't press in time and we haven't emitted a result yet
		if not qte_success and not qte_failed and not has_emitted_result:
			qte_failed = true
			label.text = "QTE Failed! Too slow!"
			handle_qte_failure()

func _input(event: InputEvent) -> void:
	if not is_qte_active or has_emitted_result:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_F:
		_on_qte_input_pressed()

func _on_qte_button_pressed():
	_on_qte_input_pressed()
func _on_qte_input_pressed():
	if not is_qte_active or has_emitted_result:
		return
	
	# Cancel the input window timer if it exists
	if input_window_timer:
		input_window_timer.timeout.disconnect(handle_qte_failure)
		input_window_timer = null
	
	var current_frame = animated_sprite.frame
	
	# Check if press happened on the correct frame
	if current_frame == 3:  # Hit window frame
		qte_success = true
		label.text = "QTE SUCCESS! Perfect timing!"
		handle_qte_success()
	else:
		label.text = "QTE Failed! Wrong frame"
		qte_failed = true
		handle_qte_failure()

func handle_qte_success():
	if has_emitted_result:
		return
	
	is_qte_active = false
	has_emitted_result = true
	animated_sprite.stop()
	
	# Emit success signal
	qte_completed.emit(true)
	
	# Clean up after delay
	await get_tree().create_timer(1.0).timeout
	queue_free()

func handle_qte_failure():
	if has_emitted_result:
		return
	
	is_qte_active = false
	has_emitted_result = true
	animated_sprite.stop()
	
	# Emit failure signal
	qte_completed.emit(false)
	
	# Clean up after delay
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_animation_finished():
	if is_qte_active and not qte_success and not qte_failed and not has_emitted_result:
		qte_failed = true
		label.text = "QTE Failed! Animation ended without press!"
		handle_qte_failure()
func _get_key_display_name(action: String) -> String:
	var events = InputMap.action_get_events(action)
	if events.size() > 0:
		var event = events[0]
		if event is InputEventKey:
			return OS.get_keycode_string(event.keycode)
		elif event is InputEventMouseButton:
			return "Mouse Button " + str(event.button_index)
	return "Button"
