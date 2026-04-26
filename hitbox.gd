extends Area2D

@export var damage = 1

@onready var hitcollision = $CollisionShape2D
@onready var disabletimer = $hitboxdisabled

func tempdisable():
	hitcollision.call_deferred("set", "disabled", true)
	disabletimer.start()

func _on_hitboxdisabled_timeout() -> void:
	hitcollision.call_deferred("set", "disabled", false)
