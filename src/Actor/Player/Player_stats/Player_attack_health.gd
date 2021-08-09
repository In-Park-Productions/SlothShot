extends Node2D

export (int) var health = 100
export (Vector2) var damage_dealt_range=Vector2(20,40)

func deal_damage(entity,damage):
	entity.health-=rand_range(damage_dealt_range.x,damage_dealt_range.y)

func health_reduced(damage):
	health-=damage
	if health<=0:
		die()

func health_increased(amount):
	if health<100:
		health+=amount


func die():
	queue_free()


