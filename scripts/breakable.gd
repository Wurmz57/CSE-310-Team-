extends StaticBody2D

@onready var solid_collision = $SolidCollision
@onready var hurtbox = $Hurtbox
@onready var hurtbox_collision = $Hurtbox/HurtboxCollision
@onready var sprite = $Sprite2D
var broken := false
@export var hp = 1
@export var break_on_any_hit = true
@export var can_break = true
#@export var damage = 1

func _break() -> void:
	print("Break")
	if broken:
		return
	broken = true	
	solid_collision.set_deferred("disabled", true)
	hurtbox_collision.set_deferred("disabled", true)

	sprite.visible = false
	

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitbox"):
		return
	hp = hp - 1
	if hp <= 0:
		_break()
