extends CharacterBody2D
@export var speed := 400.0
@export var jump_force := 250.0
@export var gravity := 1200.0

signal hit
var screen_size

# This can be replaced if for the other physics the Adam made.
func _physics_process(delta: float) -> void:
	var velocity := Vector2.ZERO
	var direction := 0.0

	if Input.is_action_pressed("move_right"):
		direction += 1.0
	if Input.is_action_pressed("move_left"):
		direction -= 1.0
		
	velocity.x = direction * speed
	
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _on_body_entered(_body):
	hide()
	hit.emit()
	#deferring physics
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
