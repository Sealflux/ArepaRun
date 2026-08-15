extends Area2D

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body : Node) -> void:
	print(body)
	print("entered")
