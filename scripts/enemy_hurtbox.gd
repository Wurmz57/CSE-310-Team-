extends Area2D

var hp = 1
@export var max_hp := 1
signal hit

func _ready() -> void:
	hp = max_hp

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitbox"):
		return
	hp = hp - 1
	hit.emit()
	if hp <= 0:
		var enemy = get_parent()
		if enemy.has_method('die'):
			enemy.die()
		else:
			enemy.queue_free()
