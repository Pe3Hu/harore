extends Node


class Token:
	var num = {}
	var word = {}

	func _init(input_):
		num.index = Global.num.primary_key.spore
		Global.num.primary_key.spore += 1
		num.edge = input_.edge
		word.type = input_.type
		word.subtype = input_.subtype

class Spore:
	var num = {}
	var arr = {}

	func _init(input_):
		num.index = Global.num.primary_key.spore
		Global.num.primary_key.spore += 1
		num.preparation = input_.preparation
		num.recharge = input_.recharge
		arr.token = input_.tokens

class DNA:
	var num = {}
	var arr = {}

	func _init(input_):
		num.index = Global.num.primary_key.dna
		Global.num.primary_key.dna += 1
		num.size = {}
		num.size.spore = 3
		arr.spore = []

	func generate_spores():
		pass

class Genome:
	var obj = {}
	var arr = {}

	func _init(input_):
		obj.boletus = input_.boletus
		arr.hand = []
		arr.discard = []
		arr.deck = []
		arr.exile = []
		init_deck()

	func init_deck():
		for dna in obj.boletus.arr.dna:
			for spore in dna.arr.spore:
				arr.deck.append(spore)

class Root:
	var num = {}

	func _init(input_):
		num.refill = {}
		num.refill.energy = input_.energy
		num.refill.spore = input_.spore

class Boletus:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		num.index = Global.num.primary_key.boletus
		Global.num.primary_key.boletus += 1
		num.size = {}
		num.refill = {}
		num.energy = {}
		num.energy.max = 100
		num.energy.current = num.energy.max
		arr.root = []
		arr.dna = []
		set_rank(input_.rank)
		get_base_roots()

	func set_rank(rank_):
		word.rank = rank_
		
		match rank_:
			"Alpha":
				num.rank = 3
			"Beta":
				num.rank = 2
			"Gamma":
				num.rank = 1
		
		num.size.dna = pow(2,num.rank)
		num.size.root = pow(2,num.rank)

	func get_base_roots():
		var refills = []
		var refill = {}
		refill.energy = 0
		refill.spore = 1
		refills.append(refill)
		
		refill = {}
		refill.energy = 1
		refill.spore = 0
		refills.append(refill)
		
		for refill_ in refills:
			var root = Classes.Root.new(refill_)
			arr.root.append(root)
		
		while arr.root.size() < num.size.root:
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0, refills.size()-1)
			var root = Classes.Root.new(refills[index_r])
			arr.root.append(root)
		
		recalc_refill()

	func recalc_refill():
		num.refill.energy = 0
		num.refill.spore = 0
		
		for root in arr.root:
			for key in root.num.refill.keys():
				num.refill[key] +=root.num.refill[key]

	func reset_genome():
		var input = {}
		input.boletus = self
		obj.genome = Classes.Genome.new(input)
		print(num.refill)

class Colony:
	var num = {}
	var arr = {}

	func _init():
		num.index = Global.num.primary_key.colony
		Global.num.primary_key.colony += 1
		arr.boletus = []
		init_boletus()

	func init_boletus():
		var input = {}
		input.rank = "Alpha"
		var boletus = Classes.Boletus.new(input)
		arr.boletus.append(boletus)

class Wood:
	var num = {}

	func _init():
		num.index = Global.num.primary_key.wood
		Global.num.primary_key.wood += 1
		num.hp = 100

class Forest:
	var arr = {}

	func _init():
		arr.wood = []
		arr.colony = []

	func add_wood(wood_):
		arr.wood.append(wood_)

	func add_colony(colony_):
		arr.colony.append(colony_)
		
	func deforestation():
		for colony in arr.colony:
			for boletus in colony.arr.boletus:
				boletus.reset_genome()

class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
