extends CharacterBody2D
signal hit
var screen_size

@export var speed := 400.0
@export var jump_force := 350.0
@export var gravity := 1200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := 0.0

	if Input.is_action_pressed("ui_right"):
		direction += 1.0
	if Input.is_action_pressed("ui_left"):
		direction -= 1.0
		
	velocity.x = direction * speed
	
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force
		
	move_and_slide()

func _on_body_entered(_body):
	hide()
	hit.emit()
	#deferring physics
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
