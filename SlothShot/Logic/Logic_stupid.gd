extends Node
class_name logic 

static func convert_int_to_bool(parameter:int):
	if parameter>0:
		return true
	elif parameter<0:
		return false
	else:
		return null
