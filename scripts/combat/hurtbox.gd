class_name HurtArea
extends Area2D

signal damaged(damage: int)

var defence = 0

func _enter_tree():
	var parent = get_parent()
	if parent:
		for g in parent.get_groups():
			if g.begins_with("actors_"):
				add_to_group(g)


func hurt(hit_area: HitArea):
	var damage: int = max(0, hit_area.damage - defence)
	damaged.emit(damage)
	return damage
