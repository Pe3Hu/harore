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
			Global.arr.token.append(token)

func init_pollens():
	for type in Global.dict.token.type.keys():
		for _i in Global.dict.token.type[type].size():
			var input = {}
			input.preparation = 0
			input.recharge = 0
			input.energy = 0
			input.tokens = [] 
			var tag = "All"
		
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
				pollen.add_tag(tag)
				pollen.add_tag(type)

func init_dnas():
	var n = 4
	#print(Global.dict.pollen.tag)
	
	for _i in n:
		var tag = "Lightning"
		var input = {}
		input.tags = [tag, "All"]
		var dna = Classes.DNA.new(input)

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
	init_colonys()
	init_forest()
	
	for tag in Global.dict.dna.tag:
		#print(tag,Global.dict.dna.tag[tag].size()) 
		for dna in Global.dict.dna.tag[tag]:
			for spore in dna.arr.spore:
				#print(spore.num, spore.arr) 
				pass

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
		Global.arr.forest[0].deforestation()
