extends Area2D

var screen_size
@export var launch_power_x: float = 125
@export var launch_power_y: float = -1000


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body : Node) -> void:
	print(body)
	print("entered")
	if body.is_in_group("player"):
		if body.has_method("launch"):
			body.launch(launch_power_x,launch_power_y)
			self.get_parent().play_anim("Espatula")
			await get_tree().create_timer(0.5).timeout
			self.queue_free()
