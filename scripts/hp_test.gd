extends StaticBody2D

signal died

@onready var solid_collision = $SolidCollision
@onready var hurtbox = $Hurtbox
@onready var hurtbox_collision = $Hurtbox/HurtboxCollision
@onready var sprite = $Sprite2D
var dead := false
var hp: int
@export var max_hp = 1
@export var break_on_any_hit = true
@export var can_break = true
#@export var damage = 1
		

func _ready():
	hp = max_hp
	
func _die() -> void:
	#print("Break")
	if dead:
		return
	dead = true	
	solid_collision.set_deferred("disabled", true)
	hurtbox_collision.set_deferred("disabled", true)

	sprite.visible = false
	died.emit()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitbox"):
		return
	hp = hp - 1
	if hp <= 0:
		_die()
