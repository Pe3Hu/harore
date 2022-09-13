extends Node


class Counter:
	var num = {}
	var word = {}
	var obj = {}
	var flag = {}

	func _init(input_):
		num.value = {}
		num.value.current = input_.value
		word.type = input_.type
		obj.wood = input_.wood
		flag.tick = false
		set_shift()

	func set_shift():
		match word.type:
			"Poison":
				num.value.shift = 1
			"Flame":
				num.value.shift = -num.value.current/2

	func harvest():
		if flag.tick:
			print(word.type,num.value.current)
			match word.type:
				"Poison":
					obj.wood.receive_damage(num.value.current)
				"Flame":
					obj.wood.receive_damage(num.value.current)
					set_shift()
					print(num.value.shift)
		
			num.value.current += num.value.shift

class Token:
	var num = {}
	var word = {}

	func _init(input_):
		Global.dict.token.type[input_.type].append(self)
		Global.dict.token.subtype[input_.subtype].append(self)
		num.edge = input_.edges
		word.type = input_.type
		word.subtype = input_.subtype
		word.stage = input_.stage

	func bloom(wood_):
		var index_f = Global.dict.token.subtype.keys().find(word.subtype)
		match word.type:
			"Wound":
				var start = 1
				var step = 2
				var charge = index_f
				var damage = Global.get_wound_hp(start, step, charge)
				wood_.receive_damage(damage)
			"Poison":
				var charge = index_f + 1
				wood_.promote_counter(word.type, charge)
			"Flame":
				var charge = Global.arr.sequence["A000124"][index_f]
				wood_.promote_counter(word.type, charge)

class Pollen:
	var num = {}
	var arr = {}
	var word = {}

	func _init(input_):
		num.preparation = input_.preparation
		num.recharge = input_.recharge
		num.energy = input_.energy
		arr.token = input_.tokens
		arr.tag = []

	func add_tag(tag_):
		arr.tag.append(tag_)
		
		if Global.dict.pollen.tag.keys().has(tag_):
			 Global.dict.pollen.tag[tag_].append(self)
		else:
			Global.dict.pollen.tag[tag_] = [self]

	func spore_nascence(dna_):
		var input = {}
		input.preparation = num.preparation
		input.recharge = num.recharge
		input.energy = num.energy
		input.tokens = arr.token
		input.tags = arr.tag
		input.dna = dna_
		var spore = Classes.Spore.new(input)
		dna_.arr.spore.append(spore)

class Spore:
	var num = {}
	var arr = {}
	var word = {}
	var obj = {}

	func _init(input_):
		num.preparation = input_.preparation
		num.recharge = input_.recharge
		num.energy = input_.energy
		arr.token = input_.tokens
		arr.tag = input_.tags
		obj.dna = input_.dna

class DNA:
	var num = {}
	var arr = {}
	var obj = {}

	func _init(input_):
		num.size = {}
		num.size.spore = 3
		arr.spore = []
		arr.tag = input_.tags
		obj.boletus = null
		generate_spores()
		
#		print("___")
#		for tag in Global.dict.dna.tag:
#			print(tag,Global.dict.dna.tag[tag].size()) 
		for tag in arr.tag:
			if Global.dict.dna.tag.keys().has(tag):
				Global.dict.dna.tag[tag].append(self)
			else:
				Global.dict.dna.tag[tag] = [self]

	func generate_spores():
		for tag in arr.tag:
			var options = []
			
			for pollen in Global.dict.pollen.tag[tag]:
				options.append(pollen)
			
			while num.size.spore > arr.spore.size() && options.size() > 0:
				Global.rng.randomize()
				var index_r = Global.rng.randi_range(0, options.size()-1)
				var pollen = options.pop_at(index_r)
				pollen.spore_nascence(self)

	func set_boletus(boletus_):
		obj.boletus = boletus_

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
		
		arr.deck.shuffle()

	func refill_hand():
		arr.hand = []
		
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
		
		if arr.hand.size() > 0:
			num.cheap = arr.hand[0].num.energy 
			
			for hand in arr.hand:
				if hand.num.energy < obj.boletus.num.energy.hand:
					arr.obtainable.append(hand)
					
					if num.cheap > hand.num.energy:
						num.cheap = hand.num.energy
		#print("hand ",obj.boletus.num.energy.hand, arr.obtainable)

	func choose_spore():
		if arr.obtainable.size() > 0:
			var spore = arr.obtainable.pop_front()
			arr.discard.append(spore)
			arr.hand.erase(spore)
			obj.boletus.num.energy.hand -= spore.num.energy
			
			for token in spore.arr.token:
				obj.boletus.obj.colony.obj.wood.add_token(token)
			print(spore.num)

	func choose_spores():
		get_obtainables()
		var i = 0
		
		while obj.boletus.num.energy.hand > num.cheap && i < 10:
			i+=1
			choose_spore()
			get_obtainables()

	func discard_hand():
		for _i in arr.hand.size():
			arr.discard.append(arr.hand.pop_back())

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
		num.size = {}
		num.refill = {}
		num.energy = {}
		num.energy.max = 100
		num.energy.current = num.energy.max
		num.energy.hand = 0
		arr.root = []
		arr.dna = []
		obj.colony = input_.colony
		set_rank(input_.rank)
		get_base_roots()
		get_base_dnas()

	func set_rank(rank_):
		word.rank = rank_
		
		match rank_:
			"Alpha":
				num.rank = 3
			"Beta":
				num.rank = 2
			"Gamma":
				num.rank = 1
		
		num.size.dna = (num.rank + 1) * 3
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

	func get_base_dnas():
		var sum = 0 
		
		while num.size.dna > sum:
			var options = Global.dict.dna.tag["All"]
			var index_r = Global.rng.randi_range(0, options.size()-1)
			var dna = options.pop_at(index_r)
			for tag in Global.dict.dna.tag:
				Global.dict.dna.tag[tag].erase(dna) 
			dna.set_boletus(self)
			arr.dna.append(dna)
			sum += dna.arr.spore.size()

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
		var shortage = energy - num.energy.hand
		num.energy.hand += shortage
		num.energy.current -= shortage

class Colony:
	var num = {}
	var arr = {}
	var obj = {}

	func _init():
		arr.boletus = []
		arr.wood = []
		init_boletus()

	func init_boletus():
		var input = {}
		input.colony = self
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
		num.hp = {}
		num.hp.max = 20
		num.hp.current = num.hp.max
		arr.counter = []
		arr.token = []
		flag.alive = true
		obj.marge = null
		
		init_counters()

	func init_counters():
		for type in Global.dict.counter.type:
			var input = {}
			input.type = type
			input.value = 0
			input.wood = self
			var counter = Classes.Counter.new(input)
			arr.counter.append(counter)

	func sowing():
		for token in arr.token:
			token.bloom(self)
		
		arr.token = []

	func add_token(token_):
		arr.token.append(token_)

	func receive_damage(damage_):
		var damage = min(num.hp.current,damage_)
		num.hp.current -= damage
		flag.alive = num.hp.current > 0
		
		if !flag.alive:
			obj.marge.next_wood(self)

	func promote_counter(type_, charge_):
		for counter in arr.counter:
			if type_ == counter.word.type:
				counter.num.value.current += charge_
				counter.flag.tick = true

class Marge:
	var num = {}
	var arr = {}
	var flag = {}
	var obj = {}

	func _init(input_):
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
		#var genome = obj.forest.arr.colony[0].arr.boletus[0].obj.genome
		#print(Global.arr.round[num.round],genome.arr.deck.size(),genome.arr.hand.size(),genome.arr.discard.size())
		match Global.dict.round.name[num.round]:
			"I":
				for wood in arr.wood:
					if wood.flag.alive:
						for counter in wood.arr.counter:
							counter.harvest()
					
					print("HP: ",wood.num.hp.current)
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
					if wood.flag.alive:
						wood.sowing()
			"V":
				for colony in obj.forest.arr.colony:
					for boletus in colony.arr.boletus:
						boletus.obj.genome.discard_hand()

	func next_round():
		num.round = (num.round + 1)%Global.dict.round.name.size()

	func next_wood(previous_):
		for colony in obj.forest.arr.colony:
			if colony.obj.wood == previous_:
				colony.obj.wood = colony.get_alive_wood()
				flag.felling.end = colony.obj.wood == null

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
