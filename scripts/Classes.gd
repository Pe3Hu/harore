extends Node


class Counter:
	var num = {}
	var word = {}
	var obj = {}
	var flag = {}

	func _init(input_):
		num.value = {}
		num.value.max = input_.value
		word.type = input_.type
		obj.wood = input_.wood
		reset()

	func set_shift():
		match word.type:
			"Poison":
				num.value.shift = 1
			"Flame":
				num.value.shift = -num.value.current/2
			"Wave":
				num.value.shift = -1
			"Lightning":
				num.value.shift = -num.value.current/2
				
				if num.value.current == 1:
					num.value.shift  = -1

	func harvest():
		if flag.tick:
			#pint(word.type,num.value.current)
			match word.type:
				"Poison":
					obj.wood.receive_damage(num.value.current)
				"Flame":
					obj.wood.receive_damage(num.value.current)
					set_shift()
				"Lightning":
					var _i = 0
					
					while num.value.current > 0 && _i < 10:
						obj.wood.receive_damage(num.value.current)
						set_shift()
						#pint(num.value.current, " - ", num.value.shift)
						num.value.current += num.value.shift
						_i += 1
					num.value.shift = 0
		
			num.value.current += num.value.shift

	func reset():
		num.value.current = num.value.max
		flag.tick = false
		set_shift()

class Token:
	var num = {}
	var word = {}

	func _init(input_):
		Global.dict.token.type[input_.type].append(self)
		Global.dict.token.subtype[input_.subtype].append(self)
		num.edge = input_.edges
		word.type = input_.type
		word.subtype = input_.subtype
		#word.stage = input_.stage
		#Global.arr.token.append(self)

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
			"Wave":
				var charge = Global.arr.sequence["A000040"][index_f]
				wood_.promote_counter(word.type, charge)
				var damage = wood_.get_counter(word.type).num.value.current
				wood_.receive_damage(damage)
			"Lightning":
				var charge = Global.arr.sequence["A001358"][index_f]
				wood_.promote_counter(word.type, charge)

class Pollen:
	var num = {}
	var word = {}
	var arr = {}
	var dict = {}

	func _init(input_):
		num.preparation = input_.preparation
		num.recharge = input_.recharge
		num.energy = input_.energy
		arr.token = input_.tokens

	func add_label_by(token_):
		if !Global.dict.pollen.label.keys().has(token_.word.type):
			Global.dict.pollen.label[token_.word.type] = {}
		
		if !Global.dict.pollen.label[token_.word.type].keys().has(token_.word.subtype):
			Global.dict.pollen.label[token_.word.type][token_.word.subtype] = []
		Global.dict.pollen.label[token_.word.type][token_.word.subtype].append(self)

	func spore_nascence(dna_):
		var input = {}
		input.preparation = num.preparation
		input.recharge = num.recharge
		input.energy = num.energy
		input.tokens = arr.token
		input.dna = dna_
		var spore = Classes.Spore.new(input)
		dna_.arr.spore.append(spore)
		
#		for tag in dict.tag:
#			for key in Global.dict.tag[tag].keys():
#				if Global.dict.pollen.tag[tag][key].has(self):
#					pint(tag,key)
		pass

class Spore:
	var num = {}
	var arr = {}
	var dict = {}
	var obj = {}

	func _init(input_):
		num.preparation = input_.preparation
		num.recharge = input_.recharge
		num.energy = input_.energy
		arr.token = input_.tokens
		obj.dna = input_.dna

	func get_data():
		var data = {}
		data.energy = num.energy
		data.tokens = []
		
		for token in arr.token:
			data.tokens.append(token.word)
		
		return data

class DNA:
	var num = {}
	var arr = {}
	var dict = {}
	var obj = {}

	func _init(input_):
		num.size = {}
		num.size.spore = 3
		num.avg = {}
		arr.spore = []
		dict.tag = {}
		arr.type = input_.types
		arr.subtype = input_.subtypes
		obj.boletus = null
		generate_spores()

	func generate_spores():
		for _i in num.size.spore:
			var options = Global.dict.pollen.label[arr.type[_i]][arr.subtype[_i]]
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0, options.size()-1)
			var pollen = options[index_r]
			pollen.spore_nascence(self)
		
		set_avgs()

	func set_avgs():
		for spore in arr.spore:
			for key in spore.num.keys():
				if !num.avg.keys().has(key):
					num.avg[key] = 0
				
				num.avg[key] += spore.num[key]/arr.spore.size()

	func set_boletus(boletus_):
		obj.boletus = boletus_
		
		for type in arr.type:
			if !obj.boletus.dict.priority.type.has(type):
				obj.boletus.dict.priority.type[type] = 0
			
			obj.boletus.dict.priority.type[type] += 1
		#rint("___________",obj.boletus.dict.priority.type)
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
		#pint("hand ",obj.boletus.num.energy.hand, arr.obtainable)

	func choose_spore():
		if arr.obtainable.size() > 0:
			var spore = arr.obtainable.pop_front()
			arr.discard.append(spore)
			arr.hand.erase(spore)
			obj.boletus.num.energy.hand -= spore.num.energy
			
			for token in spore.arr.token:
				obj.boletus.obj.colony.obj.wood.add_token(token)
				
			obj.boletus.chronicle_events(spore.get_data())

	func choose_spores():
		get_obtainables()
		var i = 0
		#pint(arr)
		
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
	var dict = {}
	var obj = {}

	func _init(input_):
		num.index = Global.num.primary_key.colony
		Global.num.primary_key.colony += 1
		num.size = {}
		num.refill = {}
		num.energy = {}
		num.energy.max = 100
		num.energy.current = num.energy.max
		num.energy.hand = 0
		arr.root = []
		arr.dna = []
		dict.priority = {}
		dict.priority.round = {}
		dict.priority.type = {}
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
		refills.append(refill)
		
		refill = {}
		refill.energy = 1
		refill.spore = 0
		refills.append(refill)
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
		define_dna_priority()

	func recalc_refill():
		num.refill.energy = 0
		num.refill.spore = 0
		
		for root in arr.root:
			for key in root.num.refill.keys():
				num.refill[key] +=root.num.refill[key]

	func define_dna_priority():
		for role in Global.dict.tag.round:
			dict.priority.round[role] = 1
		
		var sign_ = sign(num.refill.energy - num.refill.spore)
		var weight = 2
		
		match sign_:
			-1:
				dict.priority.round["III"] += weight
			0:
				dict.priority.round["IV"] += weight
			1:
				dict.priority.round["I"] += weight
		#rint(num.refill,dict.priority)

	func get_base_dnas():
		var sum = 0 
		
		while num.size.dna > sum:
			var dnas = Global.get_3_dna()
			var dna = compare_dnas(dnas)
			
			dna.set_boletus(self)
			arr.dna.append(dna)
			sum += dna.arr.spore.size()
		
		obj.colony.dict.chronicle.boletus[self] = {}
		obj.colony.dict.chronicle.boletus[self].event = []
		obj.colony.dict.chronicle.boletus[self].priority = dict.priority

	func compare_dnas(dnas_):
		var weighs = {}
		
		for dna in dnas_:
			weighs[dna] = {}
			weighs[dna].round = 0
			weighs[dna].type = 1
			
			for key in dict.priority.round.keys():
				for type in dna.arr.type:
					if Global.dict.tag.round[key].has(type):
						weighs[dna].round += dict.priority.round[key]
					if dict.priority.type.keys().has(type):
						weighs[dna].type += dict.priority.type[type]
			
			weighs[dna].value = weighs[dna].round*weighs[dna].type
			#rint(dna.arr.type, weighs[dna].value)
		
		var options = []
		
		for dna in dnas_: 
			for _i in weighs[dna].value:
				options.append(dna)
				
		Global.rng.randomize()
		var index_r = Global.rng.randi_range(0, options.size()-1)
		return options[index_r]

	func reset_genome():
		var input = {}
		input.boletus = self
		obj.genome = Classes.Genome.new(input)

	func refill_energy():
		var energy = min(num.refill.energy,num.energy.current)
		var shortage = energy - num.energy.hand
		num.energy.hand += shortage
		num.energy.current -= shortage

	func chronicle_events(data_):
		data_.round = obj.colony.obj.marge.num.round
		obj.colony.dict.chronicle.boletus[self].event.append(data_)
		obj.colony.dict.chronicle.num.round = max(obj.colony.dict.chronicle.num.round,data_.round)
		obj.colony.dict.chronicle.num.tokens += data_.tokens.size()
		obj.colony.dict.chronicle.num.energy += data_.energy

class Colony:
	var num = {}
	var arr = {}
	var dict = {}
	var obj = {}

	func _init():
		num.index = Global.num.primary_key.colony
		Global.num.primary_key.colony += 1
		arr.boletus = []
		arr.success = []
		dict.chronicle = {}
		dict.chronicle.name = self
		dict.chronicle.boletus = {}
		dict.chronicle.num = {}
		dict.chronicle.num.round = 0
		dict.chronicle.num.tokens = 0
		dict.chronicle.num.energy = 0
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
		reset()

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
			flag.success = true
			obj.marge.next_wood(self)

	func promote_counter(type_, charge_):
		for counter in arr.counter:
			if type_ == counter.word.type:
				counter.num.value.current += charge_
				counter.flag.tick = true

	func get_counter(type_):
		for counter in arr.counter:
			if counter.word.type == type_:
				return counter
			
		return null

	func reset():
		num.hp.current = num.hp.max
		flag.alive = true
		flag.success = false
		
		if arr.keys().size() == 0:
			arr.counter = []
			arr.token = []
			init_counters()
		else:
			for counter in arr.counter:
				counter.reset()

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
		reset()

	func add_wood(wood_):
		arr.wood.append(wood_)
		wood_.obj.marge = self

	func felling():
		var colony = obj.forest.obj.colony
		if !flag.felling.start && !flag.felling.end:
			colony.set_marge(self)
				
			for boletus in colony.arr.boletus:
				boletus.reset_genome()
			
			flag.felling.start = true
		
		if flag.felling.start && !flag.felling.end:
			complete_round()
			next_round()
		
		if flag.felling.start && flag.felling.end:
			print(colony.num.index, " Colony ",num.index," Marge End")

	func complete_round():
		var colony = obj.forest.obj.colony
		
		match Global.dict.round.name[num.phase]:
			"I":
				for wood in arr.wood:
					if wood.flag.alive:
						for counter in wood.arr.counter:
							counter.harvest()
					
					print(colony.num.index," HP: ",wood.num.hp.current)
			"II":
				for boletus in colony.arr.boletus:
					boletus.refill_energy()
					boletus.obj.genome.refill_hand()
			"III":
				for boletus in colony.arr.boletus:
					boletus.obj.genome.choose_spores()
			"IV":
				for wood in arr.wood:
					if wood.flag.alive:
						wood.sowing()
			"V":
				for boletus in colony.arr.boletus:
					boletus.obj.genome.discard_hand()
				num.round += 1
		
		num.timer += 1
		if num.timer == 100:
			flag.felling.end = true

	func next_round():
		num.phase = (num.phase + 1)%Global.dict.round.name.size()

	func next_wood(previous_):
		var colony = obj.forest.obj.colony
		
		if colony.obj.wood == previous_:
			colony.arr.success.append(previous_.flag.success)
			colony.obj.wood = colony.get_alive_wood()
			flag.felling.end = colony.obj.wood == null

	func reset():
		flag.felling.start = false
		flag.felling.end = false
		num.round = 0
		num.phase = 0
		num.timer = 0
		
		for wood in arr.wood:
			wood.reset()

class Forest:
	var num = {}
	var arr = {}
	var flag = {}
	var obj = {}

	func _init():
		num.marge = 0
		num.colony = -1
		arr.marge = []
		arr.colony = []
		flag.deforestation = {}
		flag.deforestation.end = false
		obj.colony = null

	func add_marge():
		var input = {}
		input.forest = self
		var marge = Classes.Marge.new(input)
		arr.marge.append(marge)

	func add_colony(colony_):
		arr.colony.append(colony_)
		
	func deforestation():
		if Global.flag.game:
			
			if !flag.deforestation.end:
				var marge = arr.marge[num.marge]
				
				if !marge.flag.felling.end:
					marge.felling()
				else:
					next_marge()
			else:
				Global.flag.game = false
				Global.num.primary_key.game += 1
				var path = "res://json/"
				var name_ = "game counter"
				var data = Global.num.primary_key.game
				Global.save_json(data,path,name_)
				
				var dir = Directory.new()
				name_ = str(Global.num.primary_key.game)
				#var date = OS.get_datetime()
				#var name_ = str(time["weekday"])
				path = path+"chronicles/"
				dir.open(path)
				dir.make_dir(name_)
				path = path+name_+"/"
				
				for colony in arr.colony:
					data = colony.dict.chronicle
					
					for _i in data.keys().size():
						var key = data.keys()[_i]
						 
						if _i != 1:
							print(key,data[key])
						else:
							for _j in data[key].keys().size():
								print(data[key].keys()[_j],data[key][data[key].keys()[_j]].size())
					
					name_ = str(colony.num.index)
					Global.save_json(data,path,name_)
				
				#Global.get_analytics()

	func next_marge():
		num.marge += 1
		
		if num.marge == arr.marge.size():
			next_colony()
			
			for marge in arr.marge:
				marge.reset() 
			flag.deforestation.end = num.colony == 0
			num.marge = 0

	func next_colony():
		if num.colony != -1:
			obj.colony.dict.chronicle.success = obj.colony.arr.success
		
		num.colony = (num.colony+1)%arr.colony.size()
		obj.colony = arr.colony[num.colony]

class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
