extends Node2D

var speed = 75
var direction = Vector2.ZERO

func _ready() -> void:
	$AnimatedSprite2D.play("fly")

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	

func _on_life_time_timeout() -> void:
	queue_free()




func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("monster"):
		queue_free()
