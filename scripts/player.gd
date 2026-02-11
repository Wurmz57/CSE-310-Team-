extends CharacterBody2D
signal hit
var screen_size
var is_attacking := false

@onready var visuals = $Visuals
@onready var sprite = $"Visuals/Animated Player Sprite"
@onready var sword_collision = $"Visuals/Sword Collision"

@export var speed := 400.0
@export var jump_force := 350.0
@export var gravity := 1200.0
@export var coyote_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	sprite.play("Swordmore")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_time += delta
	else:
		coyote_time = 0

	var direction := 0.0

	if Input.is_action_pressed("ui_right"):
		direction += 1.0
		visuals.scale.x = 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1.0
		visuals.scale.x = -1
		
	velocity.x = direction * speed
	
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("ui_up") and (is_on_floor() or coyote_time <= .1):
		velocity.y = -jump_force
		coyote_time = 1
		
	move_and_slide()
	
	if Input.is_action_pressed("attack"):
		attack()
	
	update_animation()

func _on_body_entered(_body):
	hide()
	hit.emit()
	#deferring physics
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func attack():
	if is_attacking:
		return
	
	is_attacking = true
		
	sprite.play("Sword Jab")
	
	sword_collision.start_attack()
	await sprite.animation_finished
	sword_collision.end_attack()
	
	is_attacking = false

func update_animation():
	if is_attacking:
		return
	
	if abs(velocity.x) > 0.1:
		sprite.play("Sword_walk")
	else:
		sprite.play("Swordmore") #Idle animation
	
	if not is_on_floor():
		sprite.play("Sword Jump")
