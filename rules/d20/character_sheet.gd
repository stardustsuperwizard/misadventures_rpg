class_name CharacterSheet
extends Resource

# The d20 ruleset's data shape -- a Resource-based subset of
# addons/d-20-itch-io/Components/stats/stats_component.gd's attribute-to-
# combat-stat formulas, without the Node/signal/leveling/equipment
# machinery that addon's Stats carries and Bones' Actor has no use for.
# Derived combat stats are computed getters rather than exported fields so
# there's nowhere for them to drift out of sync with the base attributes.

@export var character_name: String = "Character"

@export_group("Ability Scores")
@export var strength: int = 8
@export var dexterity: int = 8
@export var constitution: int = 8
@export var intelligence: int = 8
@export var wisdom: int = 8
@export var charisma: int = 8
@export var vitality: int = 8

@export_group("Combat")
@export var level: int = 1
# Flat AC bonus in place of the source addon's equipped-armor total --
# Bones has no inventory/equipment system to derive this from yet.
@export var armor_bonus: int = 0
@export var weapon_damage_dice: Vector2i = Vector2i(1, 4)
@export var melee_threat_range: Vector2i = Vector2i(20, 20)
@export var melee_crit_multiplier: int = 2

var current_hp: int

var max_hp: int:
	get: return _calculate_max_hp()

var armor_class: int:
	get: return 10 + _modifier(dexterity) + armor_bonus

var melee_attack_bonus: int:
	get: return level + _modifier(strength)

var melee_damage_bonus: int:
	get: return _modifier(strength)

static func _modifier(score: int) -> int:
	return floori((score - 10) / 2.0)

func _calculate_max_hp() -> int:
	var hp_per_level := maxf(1.0, 10.0 + _modifier(constitution))
	return int(vitality * 10 + level * hp_per_level)
