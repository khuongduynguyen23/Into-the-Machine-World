extends CharacterBody2D


@onready var player = get_tree().get_first_node_in_group("player")
@export var hp = 1

var data_scene = preload("res://Scenes and script/upgraded_data.tscn")

func _ready() -> void:
	$AnimatedSprite2D.play("walk")
	

func _physics_process(_delta: float) -> void:
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * global.enemyspeed
		
		move_and_slide()


func monster_die():
	var drop_chance = randf()
	if drop_chance < 0.5:
		var upgraded_data = data_scene.instantiate()
		upgraded_data.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", upgraded_data)
	$AnimatedSprite2D.play("die")
	$beforedieTimer.start()


func _on_beforedie_timer_timeout() -> void:
	self.queue_free()


func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	if hp <= 0:
		monster_die()
		
