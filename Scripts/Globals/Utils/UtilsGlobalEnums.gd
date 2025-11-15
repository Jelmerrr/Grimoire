extends Node

enum pageTypes{
	Spell,
	Buff,
	Conjure,
	Curse,
	Occult,
}

enum pageTargeting{
	Closest,
	Random,
	None,
}

enum enemyAttackTypes{
	Meelee,
	RangedAttack,
	SpellCaster,
	NoAI,
}

enum alignment{
	Player, 
	Enemy,
}

enum gameState{
	Planning,
	Combat,
	Rewarding,
}
