extends StaticBody2D


@onready var solid_collision = $SolidCollision
@onready var sprite = $Sprite2D
@onready var sprite2 = $Sprite2D2
@export var open_id: StringName = &"key"
@export var HP_lock := false
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if HP_lock == false:
		#if PlayerProgress.has_ability(open_id):
			#solid_collision.set_deferred("disabled", true)
			#sprite.visible = false
			#sprite2.visible = false
	#else:
		#pass
#if PlayerProgress.has_ability(&"sword"):



func _on_unlock_door_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if PlayerProgress.has_ability(open_id):
		solid_collision.set_deferred("disabled", true)
		sprite.visible = false
		sprite2.visible = false
