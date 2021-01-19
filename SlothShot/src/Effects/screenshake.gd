extends Node2D




onready var camera = get_parent()
onready var duration_timer=get_node("Duration")
onready var frequency_timer=get_node("Frequency")
onready var screen_shake=get_node("screen_shake")

var amplitude=0.0


func add_shake(Amplitude:float,frequency:float,duration):
	amplitude=Amplitude
	duration=duration
	
	frequency_timer.wait_time=1/float(frequency)
	duration_timer.wait_time=duration
	
	duration_timer.start()
	frequency_timer.start()
func start():
	var rand_vector=Vector2()
	rand_vector=Vector2(rand_range(-amplitude,amplitude),rand_range(-amplitude,amplitude))
	screen_shake.interpolate_property(camera,"offset",camera.offset,rand_vector,frequency_timer.wait_time,
										Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	screen_shake.start()
func reset():
	screen_shake.interpolate_property(camera,"offset",camera.offset,Vector2(),duration_timer.wait_time,
										Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	screen_shake.start()
func _on_Frequency_timeout():
	start()


func _on_Duration_timeout():
	reset()
	frequency_timer.stop()
