extends CharacterBody2D
signal hit
var screen_size
var is_attacking := false

const SWORDLESS_ANIMATIONS := {
	"idle": "Swordless",
	"walk": "Swordless_walk",
	"jump": "Swordless Jump"
}

const SWORD_ANIMATIONS := {
	"idle": "Swordmore",
	"walk": "Sword_walk",
	"jump": "Sword Jump",
	"attack": "Sword Jab"
}

@onready var visuals = $Visuals
@onready var sprite = $"Visuals/Animated Player Sprite"
@onready var sword_collision = $"Visuals/Sword Collision"

@export var speed := 400.0
@export var jump_force := 500.0
@export var gravity := 1200.0
@export var coyote_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	sprite.play(SWORDLESS_ANIMATIONS["idle"])
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
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
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	update_animation()

func has_sword() -> bool:
	return PlayerProgress.has_ability(&"sword")

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
	if not has_sword():
		return
	if is_attacking:
		return
	
	is_attacking = true
		
	sprite.play(SWORD_ANIMATIONS["attack"])
	
	sword_collision.start_attack()
	await sprite.animation_finished
	sword_collision.end_attack()
	
	is_attacking = false

func update_animation():
	if is_attacking:
		return
	
	var anims = SWORD_ANIMATIONS if has_sword() else SWORDLESS_ANIMATIONS
	
	if not is_on_floor():
		sprite.play(anims["jump"])
	elif abs(velocity.x) > 0.1:
		sprite.play(anims["walk"])
	else:
		sprite.play(anims["idle"]) #Idle animation
