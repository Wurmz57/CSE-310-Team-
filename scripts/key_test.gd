extends StaticBody2D


@onready var solid_collision = $SolidCollision
@onready var sprite = $Sprite2D
@export var ability_id: StringName = &"sword"
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerProgress.has_ability(ability_id):
		solid_collision.set_deferred("disabled", true)
		sprite.visible = false
		#sprite2.visible = false
#if PlayerProgress.has_ability(&"sword"):
