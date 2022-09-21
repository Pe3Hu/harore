extends Control


func _ready():
	var index = 78
	var data = Global.get_analytics(index)
	var parent = get_node("GridContainer")
	print(self,parent)
	
	var letters = []
	for type in Global.dict.token.type:
		letters.append(type[0])
		
	var cols = ["Index","Energy","Round"]
	cols.append_array(letters)
	parent.columns = cols.size()
	
	for col in cols:
		var label = Label.new()
		label.text = col
		parent.add_child(label)
	
	for index_ in data.keys():
		var row = []
		row.append(index_)
		
		for boletus in data[index_].boletus.keys():
			print(boletus,data[index_].boletus[boletus])
		
#		var label = Label.new()
#		label.text = str(key)
#		parent.add_child(label)
#		var data_ = data[key]
#		print(key,data_.keys())

	
	
