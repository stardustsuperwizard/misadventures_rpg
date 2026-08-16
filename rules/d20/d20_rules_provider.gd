class_name D20RulesProvider
extends RulesProvider

# Resolves attacks using CombatFormulas' d20 hit-roll/damage math (see
# combat_formulas.gd for why that's a local port rather than a live
# reference into addons/d-20-itch-io) against Bones Actors, instead of that
# addon's own Stats node. Armor-resistance mitigation is skipped: it
# depends on that addon's equipped-armor system, which Bones doesn't have;
# armor_class already gates whether an attack lands at all under this
# ruleset, so damage isn't mitigated a second time.
func resolve_attack(attacker: Actor, target: Actor) -> ActionResult:
	var a := attacker.character_sheet
	var t := target.character_sheet

	var roll := CombatFormulas.does_attack_hit(a.melee_attack_bonus, t.armor_class, a.melee_threat_range)
	if not roll.hit:
		print("%s misses %s (AC %d)" % [a.character_name, t.character_name, t.armor_class])
		return ActionResult.new(false, &"miss")

	var base_roll := CombatFormulas.roll_dice(a.weapon_damage_dice.x, a.weapon_damage_dice.y)
	var multiplier := a.melee_crit_multiplier if roll.critical else 1
	var damage := CombatFormulas.calculate_damage(base_roll, a.melee_damage_bonus, multiplier)

	print("%s %s %s for %d damage" % [a.character_name, "criticals" if roll.critical else "hits", t.character_name, damage])
	target.take_damage(damage)
	return ActionResult.new(true, &"critical_hit" if roll.critical else &"hit")
