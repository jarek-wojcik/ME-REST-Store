package model

import "math"

// xpForLevel returns the total XP required to *reach* the given level.
//
// Level 1 is reached at 100 000 XP.
// Each subsequent level uses the formula:
//
//	xpToNext(lvl) = round(250 000 * 1.0157031729 ^ (lvl - 1))
//
// So the threshold for level N (N >= 2) is:
//
//	threshold(N) = 100 000 + sum_{l=1}^{N-1} xpToNext(l)
func XPForLevel(level int) int {
	if level <= 1 {
		return 100_000
	}
	total := 100_000
	for l := 1; l < level; l++ {
		total += xpToNext(l)
	}
	return total
}

// xpToNext returns the XP required to advance from level l to level l+1.
func xpToNext(level int) int {
	return int(math.Round(250_000 * math.Pow(1.0157031729, float64(level-1))))
}

// LevelForXP returns the level corresponding to the given total XP.
// Levels are 1-based; a character with less than 100 000 XP is level 0.
func LevelForXP(xp int) int {
	if xp < 100_000 {
		return 0
	}
	level := 1
	for {
		next := XPForLevel(level + 1)
		if xp < next {
			return level
		}
		level++
	}
}
