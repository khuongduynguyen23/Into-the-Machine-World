extends Area2D

@export_enum("cooldown", "hitonce", "disablehitbox") var hurtboxtype = 0

@onready var hurtcollision = $CollisionShape2D
@onready var disabletimer = $disabletimer

signal hurt(damage)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match hurtboxtype:
				0: #cooldown
					hurtcollision.call_deferred("set", "disabled", true)
					disabletimer.start()
				1: #HitOnce
					pass
				2: #Disablehitbox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt",damage)


func _on_disabletimer_timeout() -> void:
	hurtcollision.call_deferred("set", "disabled", false)
