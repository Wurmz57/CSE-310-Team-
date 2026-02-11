extends Node

var unlocked_abilities = []

func has_ability(ability_id) -> bool:
	return unlocked_abilities.has(ability_id)
	
func unlock_ability(ability_id) -> void:
	if unlocked_abilities.has(ability_id): 
		return
	else:
		unlocked_abilities.append(ability_id)
