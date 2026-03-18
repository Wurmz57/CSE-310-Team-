extends Area2D

@export var hp = 1
signal hit

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitbox"):
		return
	hp = hp - 1
	hit.emit()
	if hp <= 0:
		get_parent().queue_free()
