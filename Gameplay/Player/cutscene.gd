extends Node2D

@onready var anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_anim("Cutscene")

func play_anim(animationName) -> void:
	anim.play(animationName)

func stop_anim() -> void:
	anim.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
