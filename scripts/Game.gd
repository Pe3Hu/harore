extends Node


func init_tokens():
	var input = {}
	input.edges = 3
	input.type = Global.dict.token.type[0]
	
	for subtype in Global.dict.token.subtype:
		input.subtype = subtype
		var token = Classes.Token.new(input)
		Global.arr.token.append(token)

func init_colonys():
	var colony = Classes.Colony.new()
	Global.arr.colony.append(colony)

func init_forest():
	var wood = Classes.Wood.new()
	var forest = Classes.Forest.new()
	forest.add_wood(wood)
	Global.arr.forest.append(forest)
	
	forest.add_colony(Global.arr.colony[0])
	forest.deforestation()

func _ready():
	init_tokens()
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
