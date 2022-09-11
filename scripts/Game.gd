extends Node


func init_tokens():
	var input = {}
	input.edges = 3
	input.type = Global.dict.token.type.keys()[0]
	input.stage = 0
	
	for subtype in Global.dict.token.subtype:
		input.subtype = subtype
		var token = Classes.Token.new(input)
		Global.arr.token.append(token)

func init_spores():
	for type in Global.dict.token.type.keys():
		var input = {}
		input.preparation = 0
		input.recharge = 1
		input.energy = 1
		input.tokens = [] 
		
		match type:
			"Wound":
				var token = null
				input.tokens.append(token)
				
		var spore = Classes.Spore.new(input) 
		Global.arr.spore.append(spore)

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
	init_tokens()
	init_spores()
	init_colonys()
	init_forest()

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
