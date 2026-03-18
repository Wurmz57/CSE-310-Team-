extends Area2D

var velocity = Vector2(0, 0)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	velocity.y += 150 * delta
	position += velocity * delta

func _on_despawn_timer_timeout() -> void:
	queue_free()
