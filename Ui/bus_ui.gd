extends CanvasLayer

@onready var animated_sprite = $PanelContainer/AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func playCooldown():
	animated_sprite.play("Cooldown")
	
func stopCooldown():
	animated_sprite.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
