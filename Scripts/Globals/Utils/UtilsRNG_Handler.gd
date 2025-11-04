extends Node

var rng = RandomNumberGenerator.new()
var seedrng = RandomNumberGenerator.new()
@export var seed_input: String = "" #initial seed input for manual overwrite

func _ready() -> void:
	if seed_input == "":
		random_seed()
	elif seed_input != "":
		change_seed(seed_input)

func change_seed(new_seed): #Change seed based on input.
	rng.seed = hash(new_seed)

func random_seed(): #Generate a new random seed, should be called when no pre-determined seed was chosen.
	var randomseed = seedrng.randi_range(1, 2147483647)
	var randomized_seed = str(randomseed)
	rng.seed = hash(randomized_seed)
