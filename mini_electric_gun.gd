extends Node2D

@onready var Radar = $Radar
@onready var screensize = get_viewport_rect().size

var electric_bullet_scene = preload("res://Scenes and script/electric.tscn")

var bullet_count = 1

func _on_attack_timer_timeout() -> void:
	var monster_list = Radar.get_overlapping_bodies()
	var closet_target = null
	var closet_distance = 1000
	
	for monster in monster_list:
		if monster.is_in_group("monster"):
			var distance = global_position.distance_to(monster.global_position)
			if distance < closet_distance:
				closet_distance = distance
				closet_target = monster
	if closet_target != null:
		print("found", closet_target.name)
		var diff = closet_target.global_position - global_position
		
		if abs(diff.x) <= screensize.x/2 and abs(diff.y) <= screensize.y/2:
			var shoot_direction = global_position.direction_to(closet_target.global_position)
			for i in range(bullet_count):
				var electric_bullet = electric_bullet_scene.instantiate()
				electric_bullet.global_position = global_position
				#bullet direction
				
				#bullet angle
				var spread_angle = 0.0
				if bullet_count > 1:
					spread_angle = deg_to_rad(15) * (i - (bullet_count -1) / 2)
				var final_direction = shoot_direction.rotated(spread_angle)
				
				electric_bullet.direction = final_direction
				#change the sprite direction
				electric_bullet.rotation = final_direction.angle()
				#shoot
				get_tree().current_scene.add_child(electric_bullet)
