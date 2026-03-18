extends StaticBody2D


@onready var solid_collision = $SolidCollision
@onready var sprite = $Sprite2D
@export var ability_id: StringName = &"NULL"
@export var door_id: StringName = &"NULL"
var opened := false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	# This line “subscribes” the door to the global event
	DoorEvents.enemy_defeated.connect(_on_enemy_defeated)

func _process(_delta: float) -> void:
	if PlayerProgress.has_ability(ability_id) and ability_id != &"NULL":
		_open()

func _on_enemy_defeated(defeated_id: StringName):
	if defeated_id != door_id and door_id != &"NULL":
		return
	_open()

func _open():
	if opened:
		return
	opened = true
	solid_collision.set_deferred("disabled", true)
	sprite.visible = false
