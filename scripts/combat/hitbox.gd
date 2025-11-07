class_name HitArea
extends Area2D

@onready var hit_area: HitArea = $Area2D
@onready var actor = get_parent()


signal hit_landed(damage: int)

var damage = 1

func _enter_tree():
	var parent = get_parent()
	if parent:
		for g in parent.get_groups():
			if g.begins_with("actors_"):
				add_to_group(g)

func _ready() -> void:
	hit_area.area_entered.connect(hit)


func shares_group_with(other: Node) -> bool:
	for g in get_groups():
		if other.is_in_group(g):
			return true
	return false


func hit(hurt_area: HurtArea) -> void:
	if shares_group_with(hurt_area):
		hit_landed.emit(hurt_area.hurt(self))
