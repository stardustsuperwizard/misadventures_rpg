class_name CombatFormulas

# Verbatim port of the dice/hit-roll math from
# addons/d-20-itch-io/Components/Combat/CombatFormulas.gd -- just the three
# functions that only take primitives (no dependency on that addon's Stats/
# ArmorItem/inventory types). Ported rather than called in place because
# addons/d-20-itch-io is a full standalone Godot project (its own
# project.godot, autoloads, Player/MainMenu) dropped into addons/ wholesale,
# not a plugin; Godot treats a nested project.godot as a project boundary
# and refuses to scan anything under it, so none of its classes are
# reachable from here, and one broken script deep in its own Player/UI
# tree (missing SaveLoadManager/CharacterCreationData autoloads it expects
# from its own project) would otherwise cascade-fail the whole project's
# global script class build if that tree were live-referenced.

const CRIT_MISS: int = 1

## Resolves an attack roll against a defense value.
## Returns { "hit": bool, "critical": bool }
static func does_attack_hit(attack_mod: int, defense: int, threat_range: Vector2i) -> Dictionary:
	var d20 := randi_range(1, 20)
	if d20 == CRIT_MISS:
		return { "hit": false, "critical": false }
	if d20 >= threat_range.x and d20 <= threat_range.y:
		return { "hit": true, "critical": true }
	return { "hit": (d20 + attack_mod) >= defense, "critical": false }

## Rolls count x sides dice and returns the sum. e.g. roll_dice(2, 6) = 2d6
static func roll_dice(count: int, sides: int) -> int:
	var total := 0
	for i in count:
		total += randi_range(1, sides)
	return total

## Returns final damage value after crit, minimum 1.
static func calculate_damage(base_roll: int, attribute_mod: int, crit_multiplier: int = 1) -> int:
	return maxi(1, (base_roll + attribute_mod) * crit_multiplier)
