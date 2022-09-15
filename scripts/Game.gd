extends Node


func init_tokens():
	for _i in Global.dict.token.type.keys().size():
		var input = {}
		input.edges = 3
		input.type = Global.dict.token.type.keys()[_i]
		input.stage = 0
		
		for subtype in Global.dict.token.subtype:
			input.subtype = subtype
			var token = Classes.Token.new(input)

func init_pollens():
	for type in Global.dict.token.type.keys():
		for _i in Global.dict.token.type[type].size():
			var input = {}
			input.preparation = 0
			input.recharge = 0
			input.energy = 0
			input.tokens = [] 
		
			match type:
				"Wound":
					input.recharge = _i + 1
					input.energy = _i + 1
					var token = Global.dict.token.type[type][_i]
					input.tokens.append(token)
				"Poison":
					input.recharge = _i + 1
					input.energy = Global.arr.sequence["A000040"][_i]
					var token = Global.dict.token.type[type][_i]
					input.tokens.append(token)
				"Flame":
					input.recharge = _i + 1
					input.energy = Global.arr.sequence["A000040"][_i]
					var token = Global.dict.token.type[type][_i]
					input.tokens.append(token)
				"Wave":
					input.recharge = _i + 1
					input.energy = Global.arr.sequence["A000040"][_i]
					var token = Global.dict.token.type[type][_i]
					input.tokens.append(token)
				"Lightning":
					input.recharge = _i + 1
					input.energy = Global.arr.sequence["A000040"][_i+1]
					var token = Global.dict.token.type[type][_i]
					input.tokens.append(token)
			
			if input.tokens.size() > 0:
				var pollen = Classes.Pollen.new(input) 
				
				for token in input.tokens:
					pollen.add_tag_by(token)

func init_dnas():
	var n = 1
	#print(Global.dict.pollen.tag)
	
	for _i in n:
		var input = {}
		input.tag = {}
		input.tag.type = []
		input.tag.round = []
		input.tag.energy = []
		var size_ = 1
		
		while input.tag.type.size() + input.tag.energy.size() + input.tag.round.size() < size_:
			var options = input.tag.keys()
			var index_r = Global.rng.randi_range(0, options.size()-1)
			var key = options[index_r]
			
			options = Global.dict.dna.tag[key].keys()
			index_r = Global.rng.randi_range(0, options.size()-1)
			var tag = options[index_r]
			print(tag)
			input.tag[key].append(tag)
		var dna = Classes.DNA.new(input)
	
	print(Global.dict.dna.tag)

func init_colonys():
	var colony = Classes.Colony.new()
	Global.arr.colony.append(colony)

func init_forest():
	var forest = Classes.Forest.new()
	forest.add_marge()
	var wood = Classes.Wood.new()
	forest.arr.marge[0].add_wood(wood)
	
	forest.add_colony(Global.arr.colony[0])
	Global.arr.forest.append(forest)

func _ready():
	Global.flag.game = true
	var path = "res://json/"
	var name_ = "game counter"
	Global.num.primary_key.game = Global.load_json(path,name_)
	
	init_tokens()
	init_pollens()
	init_dnas()
	#init_colonys()
	#init_forest()
	
#	for tag in Global.dict.dna.tag:
#		#pint(tag,Global.dict.dna.tag[tag].size()) 
#		for dna in Global.dict.dna.tag[tag]:
#			for spore in dna.arr.spore:
#				#pint(spore.num, spore.arr) 
#				pass

func _input(event):
	if event is InputEventMouseButton:
		if Global.flag.click:
			pass
		else:
			Global.flag.click = !Global.flag.click

func _process(delta):
	pass

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
		#Global.arr.forest[0].deforestation()
