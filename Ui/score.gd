extends CanvasLayer

@onready var score_label = $ScoreLabel

var score: int = 0
var distance: float = 0
var max_distance: float = 0
var player: Node2D = null

func _ready():
	# Find the player
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("⚠️ Player not found! Make sure player has 'player' group")
	
	update_score_display()

func _process(delta):
	if player == null:
		return
	
	# Track distance (player moves right)
	distance = player.position.x
	if distance > max_distance:
		max_distance = distance
	# Calculate score (1 point per 100 pixels)
	score = int(max_distance / 100)
	
	# Update the display
	update_score_display()

func update_score_display():
	score_label.text = "Score: " + str(score)
