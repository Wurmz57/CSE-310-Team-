extends StaticBody2D


@onready var solid_collision = $SolidCollision
@onready var sprite_back = $BackSprite
@onready var sprite_front = $FrontSprite
@onready var sprite_ani = $DoorAnimation
@export var open_id: StringName = &"key"

func _ready() -> void:
	sprite_ani.play("Idle animation")


func _on_unlock_door_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if PlayerProgress.has_ability(open_id):
		solid_collision.set_deferred("disabled", true)
		sprite_ani.visible = false
		sprite_back.visible = true
		sprite_front. visible = true
