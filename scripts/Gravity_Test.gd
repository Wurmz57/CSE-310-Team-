extends CharacterBody2D

@export var gravity_scale = 1.0
@export var max_fall_speed = 1300

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	#print(velocity)s
