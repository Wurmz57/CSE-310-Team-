extends Area2D

var hp: int
@export var max_hp := 1

func _ready() -> void:
	hp = max_hp

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitbox"):
		return
	hp = hp - 1
	if hp <= 0:
		var enemy = get_parent()
		enemy.die()
