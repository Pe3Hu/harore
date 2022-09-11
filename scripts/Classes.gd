extends Node



class Counter:
	var num = {}
	var word = {}

	func _init(input_):
		num.value = input_.value
		word.name = input_.name

	func harvest():
		match word.name:
			"":
				pass

	func shift():
		match word.name:
			"":
				pass

class Token:
	var num = {}
	var word = {}

	func _init(input_):
		num.index = Global.num.primary_key.spore
		Global.dict.token.type[input_.type].append(num.index)
		Global.dict.token.subtype[input_.subtype].append(num.index)
		Global.num.primary_key.spore += 1
		num.edge = input_.edges
		word.type = input_.type
		word.subtype = input_.subtype
		word.stage = input_.stage

	func bloom(wood_):
		match word.type:
			"Wound":
				var damage = 0
				wood_.receive_damage(damage)

class Spore:
	var num = {}
	var arr = {}
	var word = {}

	func _init(input_):
		num.index = Global.num.primary_key.spore
		Global.num.primary_key.spore += 1
		num.preparation = input_.preparation
		num.recharge = input_.recharge
		num.energy = input_.energy
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
	var num = {}
	var arr = {}

	func _init(input_):
		obj.boletus = input_.boletus
		arr.hand = []
		arr.discard = []
		arr.deck = []
		arr.exile = []
		arr.obtainable = []
		num.cheap = -1
		init_deck()

	func init_deck():
		for dna in obj.boletus.arr.dna:
			for spore in dna.arr.spore:
				arr.deck.append(spore)

	func refill_hand():
		for _i in obj.boletus.num.refill.spore:
			get_spore()

	func get_spore():
		if arr.deck.size() > 0:
			arr.hand.append(arr.deck.pop_back())
		else:
			reshuffle() 

	func reshuffle():
		for _i in arr.discard.size():
			arr.deck.append(arr.discard.pop_back())
		
		arr.deck.shuffle()

	func get_obtainables():
		arr.obtainable = []
		num.cheap = arr.hand[0].num.energy 
		
		for hand in arr.hand:
			if hand.num.energy < obj.boletus.num.energy.hand:
				arr.obtainable.append(hand)
				
				if num.cheap > hand.num.energy:
					num.cheap = hand.num.energy

	func choose_spore():
		var spore = arr.obtainable.pop_front()
		
		for token in spore.arr.token:
			obj.boletus.arr.token
		

	func choose_spores():
		get_obtainables()
		
		while obj.boletus.num.energy.hand > num.cheap:
			choose_spore()
			get_obtainables()

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
		num.energy.hand = 0
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

	func refill_energy():
		var energy = min(num.refill.energy,num.energy.current)
		num.energy.hand += energy
		num.energy.current -= energy

class Colony:
	var num = {}
	var arr = {}
	var obj = {}

	func _init():
		num.index = Global.num.primary_key.colony
		Global.num.primary_key.colony += 1
		arr.boletus = []
		arr.wood = []
		init_boletus()

	func init_boletus():
		var input = {}
		input.rank = "Alpha"
		var boletus = Classes.Boletus.new(input)
		arr.boletus.append(boletus)

	func set_marge(marge_):
		obj.marge = marge_
		obj.wood = get_alive_wood()

	func get_alive_wood():
		for wood in obj.marge.arr.wood:
			if wood.flag.alive:
				return wood
		return null

class Wood:
	var num = {}
	var arr = {}
	var flag = {}
	var obj = {}

	func _init():
		num.index = Global.num.primary_key.wood
		Global.num.primary_key.wood += 1
		num.hp = {}
		num.hp.max = 100
		num.hp.current = num.hp.max
		arr.counter = []
		arr.token = []
		flag.alive = true
		obj.marge = null

	func sowing():
		for token in arr.token:
			token.bloom(self)

	func receive_damage(damage_):
		var damage = min(num.hp.current,damage_)
		num.hp.current -= damage
		flag.alive = num.hp.current > 0

class Marge:
	var num = {}
	var arr = {}
	var flag = {}
	var obj = {}

	func _init(input_):
		num.index = Global.num.primary_key.marge
		Global.num.primary_key.marge += 1
		obj.forest = input_.forest
		arr.wood = []
		flag.felling = {}
		flag.felling.start = false
		flag.felling.end = false
		num.round = 0

	func add_wood(wood_):
		arr.wood.append(wood_)
		wood_.obj.marge = self

	func felling():
		if !flag.felling.start && !flag.felling.end:
			for colony in obj.forest.arr.colony:
				colony.set_marge(self)
				
				for boletus in colony.arr.boletus:
					boletus.reset_genome()
			
			flag.felling.start = true
		
		if flag.felling.start && !flag.felling.end:
			complete_round()
			next_round()
		
		if flag.felling.start && flag.felling.end:
			print("Marge End")
		
	func complete_round():
		print(Global.arr.round[num.round])
		match Global.arr.round[num.round]:
			"I":
				for wood in arr.wood:
					for counter in wood.arr.counter:
						counter.harvest()
			"II":
				for colony in obj.forest.arr.colony:
					for boletus in colony.arr.boletus:
						boletus.refill_energy()
						boletus.obj.genome.refill_hand()
			"III":
				for colony in obj.forest.arr.colony:
					for boletus in colony.arr.boletus:
						boletus.obj.genome.choose_spores()
			"IV":
				for wood in arr.wood:
					wood.sowing()

	func next_round():
		num.round = (num.round + 1)%Global.arr.round.size()



class Forest:
	var arr = {}
	var num = {}
	var flag = {}

	func _init():
		arr.marge = []
		arr.colony = []
		num.marge = 0
		flag.deforestation = {}
		flag.deforestation.end = false

	func add_marge():
		var input = {}
		input.forest = self
		var marge = Classes.Marge.new(input)
		arr.marge.append(marge)

	func add_colony(colony_):
		arr.colony.append(colony_)
		
	func deforestation():
		if !flag.deforestation.end:
			var marge = arr.marge[num.marge]
			
			if !marge.flag.felling.end:
				marge.felling()
			else:
				next_marge()

	func next_marge():
		num.marge += 1
		flag.deforestation.end = num.marge == arr.marge.size()

class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
