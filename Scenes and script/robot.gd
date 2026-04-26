extends CharacterBody2D

var victory_item_scene = preload("res://Scenes and script/victory_item.tscn")
var data_collected = 0
var data_to_upgrade = 0
var upgrade_milestone = 2
var is_victory_item_spawn = false
var is_dead = false

func _ready() -> void:
	$UpgradeMenu.hide()
	

func _physics_process(_delta: float) -> void:
	$Label.text = str(global.playerhealth)
	$HUD/Data2Up.text = "To upgrade: " + str(data_to_upgrade) + "/" + str(upgrade_milestone)
	$HUD/TotalData.text = "Total data: " + str(data_collected)
	velocity = Vector2.ZERO
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimatedSprite2D.flip_h = true

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * global.playerspeed
		$AnimatedSprite2D.play("Walk")
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, global.againstspeed)
		$AnimatedSprite2D.play("Idle")
	move_and_slide()


func _on_hurtbox_hurt(damage: Variant) -> void:
	if is_dead == true:
		return
	global.playerhealth -= damage
	if global.playerhealth <= 0:
		is_dead = true
		you_die()

func collect_data_upgrade():
	data_collected += 1
	data_to_upgrade += 1
	if data_collected >= 100:
		spawn_victory_item()
	if data_to_upgrade == upgrade_milestone:
		$UpgradeMenu.show()
		get_tree().paused = true

func spawn_victory_item():
	is_victory_item_spawn = true
	var victory_item = victory_item_scene.instantiate()
	#random angle
	var random_angle = randf_range(0, 2 * PI)
	var distance = 2500
	var victory_offset = Vector2.RIGHT.rotated(random_angle) * distance
	victory_item.global_position = global_position + victory_offset
	get_tree().current_scene.call_deferred("add_child", victory_item)


func _on_upgrade_button_pressed() -> void:
	get_tree().paused = false
	$UpgradeMenu.hide()
	$Weapon/MiniElectricGun.bullet_count += 1
	data_to_upgrade = 0
	upgrade_milestone += 1
	if is_dead == false:
		global.playerhealth += 5
	
func you_die():
	$AnimatedSprite2D.play("Die")
	get_tree().set_deferred("paused", true)
	get_tree().call_deferred("change_scene_to_file","res://Scenes and script/game_over.tscn")
