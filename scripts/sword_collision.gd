extends Area2D


# The damage number is arbitrary and can be replaced.
# This is more for placeholding than anything.
@export var damage := 10
var hit_targets := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false

func start_attack():
	hit_targets.clear()
	monitoring = true

func end_attack():
	monitoring = false
	hit_targets.clear()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body not in hit_targets:
		hit_targets.append(body)
		body.take_damage(damage)
