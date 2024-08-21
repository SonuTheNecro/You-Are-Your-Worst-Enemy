extends Panel
var time : float = 0.0
var minutes: int = 0
var seconds: int = 0
var mili   : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	mili = fmod(time,1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time,3600) / 60
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Mili.text = "%03d"      % mili

func stop_timer():
	set_process(false)
