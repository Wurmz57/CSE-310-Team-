extends CharacterBody2D
signal hit
var screen_size
var is_attacking := false
var is_crouching := false
var is_sliding := false

const SWORDLESS_ANIMATIONS := {
	"idle": "Swordless",
	"walk": "Swordless Walk",
	"jump": "Swordless Jump",
	"crouch": "Swordless Crouch",
	"slide": "Swordless Slide"
}

const SWORD_ANIMATIONS := {
	"idle": "Swordmore",
	"walk": "Sword Walk",
	"jump": "Sword Jump",
	"attack": "Sword Jab",
	"crouch": "Sword Crouch",
	"slide": "Sword Slide"
}

@onready var visuals = $Visuals
@onready var sprite = $"Visuals/Animated Player Sprite"
@onready var sword_collision = $"Visuals/Sword Collision"
@onready var standing_collision = $"Standing Collision"
@onready var crouching_collision =$"Crouching Collision"

@export var speed := 400.0
@export var jump_force := 500.0
@export var gravity := 1200.0
@export var slide_speed := 800.0
@export var slide_friction := 2000.0
var coyote_time = 0
@export var hp = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	sprite.play(SWORDLESS_ANIMATIONS["idle"])
	
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
		
	if not is_crouching and not is_sliding:
		velocity.x = direction * speed

	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or coyote_time <= .1):
		velocity.y = -jump_force
		coyote_time = 1
	
#	Crouch check
	is_crouching = Input.is_action_pressed("crouch") and is_on_floor() and not is_sliding
#	Sliding check
	if Input.is_action_just_pressed("slide") \
	and is_crouching \
	and not is_sliding:
		start_slide()
	
	if is_sliding:
		velocity.x = move_toward(velocity.x, 0, slide_friction * delta)
		
		if abs(velocity.x) < 50:
			is_sliding = false
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	update_animation()
	update_collision()

func has_sword() -> bool:
	return PlayerProgress.has_ability(&"sword")

func update_collision():
	if is_sliding or is_crouching:
		standing_collision.disabled = true
		crouching_collision.disabled = false
	else:
		standing_collision.disabled = false
		crouching_collision.disabled = true

func start_slide():
	is_sliding = true
	is_crouching = false
	
	var dir = visuals.scale.x
	velocity.x = dir * slide_speed

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
	# prevent attacking if no sword
	
	if not PlayerProgress.has_ability(&"sword"):
		return
	
	is_attacking = true
		
	sprite.play(SWORD_ANIMATIONS["attack"])
	
	sword_collision.start_attack()
	await sprite.animation_finished
	sword_collision.end_attack()
	
	is_attacking = false

func safe_play(anim: String):
	if sprite.animation != anim:
		sprite.play(anim)

func update_animation():
	if is_attacking:
		return
	
	var anims = SWORD_ANIMATIONS if has_sword() else SWORDLESS_ANIMATIONS
	
	if is_sliding:
		safe_play(anims["slide"])
		return
	
	if is_crouching:
		safe_play(anims["crouch"])
		return
	
	if not is_on_floor():
		safe_play(anims["jump"])
	elif abs(velocity.x) > 0.1:
		safe_play(anims["walk"])
	else:
		safe_play(anims["idle"]) #Idle animation

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
		print('You got hit!')
		hp -= 1
		if hp <= 0:
			print('You died!')
