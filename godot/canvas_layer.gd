extends CanvasLayer

@onready var HandType: Label = $"../CanvasLayer/HandType"
@onready var attempts: Label = $"../CanvasLayer/Attempts"
@onready var ping: Label = $"../CanvasLayer/Ping"
@onready var hand_tracker = $"../HandTracking"

var attempt_count: int = 0
const MAX_PING_SAMPLES := 20
var ping_samples: Array = []

func _process(_delta: float) -> void:
	var visible_hands = []
	
	if hand_tracker.left_hand.is_active():
		visible_hands.append("RIGHT")
	if hand_tracker.right_hand.is_active():
		visible_hands.append("LEFT")

	HandType.text = "HAND TYPE: " + (", ".join(visible_hands) if visible_hands.size() > 0 else "NONE")

func increment_attempts() -> void:
	attempt_count += 1
	attempts.text = "ATTEMPTS: %d" % attempt_count

func update_ping(new_ping: int) -> void:
	ping_samples.append(new_ping)
	if ping_samples.size() > MAX_PING_SAMPLES:
		ping_samples.pop_front()

	var total := 0
	for ping in ping_samples:
		total += ping
	
	var average_ping := total / ping_samples.size()
	display_ping(round(average_ping))
	
func display_ping(ping_value) -> void:
	ping.text = "PING: %d" % ping_value
