extends Area2D

var screen_size
@export var speeddecrease: float = -200

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
		if body.has_method("speedadjust"):
			body.speedadjust(speeddecrease)
			self.queue_free()
