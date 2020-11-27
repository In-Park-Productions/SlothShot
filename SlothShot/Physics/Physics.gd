extends Node
class_name physics

static func calculate_projectile(player_position:Vector2,mouse_position:Vector2,gravity:float,air_resistance:float):
	var velocity_vector=Vector2()
	var angle=(player_position-mouse_position).angle()
	velocity_vector.x=cos(angle)
	velocity_vector.y+=sin(angle)-(gravity+air_resistance)
	velocity_vector=velocity_vector.normalized()
	var squared_vector=pow(velocity_vector.x,2)+pow(velocity_vector.y,2)
	var vector_maginitude=sqrt(squared_vector)
	print(rad2deg(angle))

	return velocity_vector
