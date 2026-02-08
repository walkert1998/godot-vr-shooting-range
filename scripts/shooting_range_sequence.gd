extends Node

@export var round_targets_1: Array[RangeTarget]
@export var round_targets_2: Array[RangeTarget]
@export var round_targets_3: Array[RangeTarget]
var current_round: int = 0
var round_targets: Array[RangeTarget]

func start_round(round: int=0):
	match round:
		0:
			round_targets = round_targets_1
		1:
			round_targets = round_targets_2
		2:
			round_targets = round_targets_3
	for target: RangeTarget in round_targets:
		target.popup()

func check_if_round_done() -> bool:
	for target: RangeTarget in round_targets:
		if target.target_up:
			return false
	if current_round < 2:
		current_round += 1
		start_round(current_round)
	return true
