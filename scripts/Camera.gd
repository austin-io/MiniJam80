extends Camera

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

onready var camera = self;

func start(duration = 0.2, frequency = 20, amplitude = 0.2, priority = 0):
	if (priority >= self.priority):
		self.priority = priority
		self.amplitude = amplitude

		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()

		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(self, "h_offset", self.h_offset, rand.x, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.interpolate_property(self, "v_offset", self.v_offset, rand.y, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func _reset():
	$ShakeTween.interpolate_property(self, "h_offset", self.h_offset, 0, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.interpolate_property(self, "v_offset", self.v_offset, 0, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

	priority = 0


func _on_Frequency_timeout():
	_new_shake();


func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
