extends StaticBody2D


@onready var solid_collision = $SolidCollision
@onready var sprite = $Sprite2D
@onready var sprite2 = $Sprite2D2
@onready var sprite3 = $Sprite2D3
@onready var sprite4 = $Sprite2D4
@onready var sprite5 = $Sprite2D5
@onready var sprite6 = $Sprite2D6
@onready var sprite7 = $Sprite2D7
@onready var sprite8 = $Sprite2D8
@onready var sprite9 = $Sprite2D9
#@export var ability_id: StringName = &"NULL"
@export var door_id: StringName = &"NULL"
var opened := false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	# This line “subscribes” the door to the global event
	DoorEvents.enemy_defeated.connect(_on_enemy_defeated)

#func _process(delta: float) -> void:
	#if PlayerProgress.has_ability(ability_id) and ability_id != &"NULL":
		#_open()

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
	sprite2.visible = false
	sprite3.visible = false
	sprite4.visible = false
	sprite5.visible = false
	sprite6.visible = false
	sprite7.visible = false
	sprite8.visible = false
	sprite9.visible = false
