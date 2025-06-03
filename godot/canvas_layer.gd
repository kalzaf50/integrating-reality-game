extends CanvasLayer

@onready var HandType: Label = $"../CanvasLayer/HandType"
@onready var attempts: Label = $"../CanvasLayer/Attempts"
@onready var hand_tracker = $"../HandTracking"

var attempt_count: int = 0

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
