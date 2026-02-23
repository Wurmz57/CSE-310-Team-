extends StaticBody2D

@onready var solid_collision = $SolidCollision
@onready var hurtbox = $Hurtbox
@onready var hurtbox_collision = $Hurtbox/HurtboxCollision
@onready var ani_sprite = $AnimatedSprite2D
var broken := false
var hp: int
@export var max_hp = 1
@export var break_on_any_hit = true
@export var can_break = true
@export var break_animation_name: String = "break"
@export var idle_name: String = "unbroken"
@export var broken_name: String = "broken"
#@export var damage = 1
		

func _ready():
	hp = max_hp
	
func _break() -> void:
	print("Break")
	if broken:
		return
	broken = true	
	print("Playing break animation:", break_animation_name)
	solid_collision.set_deferred("disabled", true)
	hurtbox_collision.set_deferred("disabled", true)

	ani_sprite.stop()
	ani_sprite.play(break_animation_name)
	await ani_sprite.animation_finished
	ani_sprite.play(broken_name)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitbox"):
		return
	hp = hp - 1
	if hp <= 0:
		_break()
