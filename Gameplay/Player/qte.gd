extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var qte_button = $Button
@onready var label = $Label
var is_qte_active: bool = false
var qte_success: bool = false
var qte_failed: bool = false

func _ready():
	# Connect button signal
	qte_button.pressed.connect(_on_qte_button_pressed)
	
	# Connect animation signals
	animated_sprite.frame_changed.connect(_on_frame_changed)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	await get_tree().create_timer(1.5).timeout
	start_qte()

func start_qte():
	is_qte_active = true
	qte_success = false
	qte_failed = false
	
	# Play the QTE animation
	animated_sprite.play("QTE")
	label.text = ("QTE Started! Press button on the right frame!")

func _on_frame_changed():
	if not is_qte_active:
		return
	
	var current_frame = animated_sprite.frame
	var animation = animated_sprite.animation
	
	# Check if we're on the "hit window" frame
	if animation == "QTE" and current_frame == 3:  # Frame 3 = hit window
		label.text = ("PRESS NOW! (Frame 3)")
		var window_timer = get_tree().create_timer(0.2)  # 200ms window
		await window_timer.timeout
		
		# If player didn't press in time
		if not qte_success and not qte_failed:
			qte_failed = true
			label.text = ("QTE Failed! Too slow!")
			handle_qte_failure()

func _on_qte_button_pressed():
	if not is_qte_active:
		return
	
	var current_frame = animated_sprite.frame
	
	# Check if press happened on the correct frame
	if current_frame == 3:  # Hit window frame
		qte_success = true
		label.text = ("QTE SUCCESS! Perfect timing!")
		handle_qte_success()
	else:
		label.text = ("QTE Failed! Wrong frame")
		qte_failed = true
		handle_qte_failure()

func handle_qte_success():
	is_qte_active = false
	# Do something awesome!
	label.text = ("Completed QTE!")
	animated_sprite.stop()
	await get_tree().create_timer(1).timeout
	label.text = ("New QTE in 1 second")
	await get_tree().create_timer(1).timeout
	start_qte()
	# Play success animation, deal damage, etc.

func handle_qte_failure():
	is_qte_active = false
	# Do something bad!
	label.text = ("Failed QTE!")
	animated_sprite.stop()
	await get_tree().create_timer(1).timeout
	label.text = ("New QTE in 1 second")
	await get_tree().create_timer(1).timeout
	start_qte()
	# Play failure animation, take damage, etc.

func _on_animation_finished():
	if is_qte_active and not qte_success:
		qte_failed = true
		label.text = ("QTE Failed! Animation ended without press!")
		handle_qte_failure()
	
