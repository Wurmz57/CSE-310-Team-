extends CharacterBody2D

var direction = 1
var speed = 0
var activated = false
var attacks = 10
var player
@export var slime_ball_scene: PackedScene

func _ready():
	$RayCast2D.add_exception(get_parent().get_node('Player'))
	$AnimatedSprite2D.play('default')
	player = get_parent().get_node('Player')

func _process(delta):
	if position.distance_squared_to(player.position) <= 100000 and not activated:
		speed = 60
		$AttackTimer.start()
		activated = true
	if $RayCast2D.is_colliding():
		direction *= -1
		scale.x *= -1
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = speed * direction
	if $StunTimer.is_stopped():
		move_and_slide()

func _on_enemy_hurtbox_hit() -> void:
	$StunTimer.start()
	$Invulnerability.start()
	speed *= 1.15
	$EnemyHurtbox.get_node('CollisionShape2D').set_deferred('disabled', true)

func _on_stun_timer_timeout() -> void:
	if get_parent().get_node('Player').position.x > position.x:
		if direction == 1:
			scale.x *= -1
		direction = -1
	else:
		if direction == -1:
			scale.x *= -1
		direction = 1

func _on_invulnerability_timeout() -> void:
	$EnemyHurtbox.get_node('CollisionShape2D').set_deferred('disabled', false)

func _on_attack_timer_timeout() -> void:
	var slime_ball = slime_ball_scene.instantiate()
	slime_ball.position = position
	slime_ball.velocity = Vector2(0, randf_range(-100, -400)).rotated(randf_range(-PI/3, PI/3))
	get_parent().add_child(slime_ball)
	attacks -= 1
	if attacks <= 0:
		$AttackTimer.stop()
		$AttackTimer2.start()

func _on_attack_timer_2_timeout() -> void:
	$AttackTimer.start()
	attacks = 40 - $EnemyHurtbox.hp * 3

func die():
	print("boss defeated")
	DoorEvents.enemy_defeated.emit("bossDoor")
	queue_free()
