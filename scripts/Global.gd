extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}

func init_num():
	init_primary_key()
	
	num.size = {}
	num.size.dna = 3

func init_primary_key():
	num.primary_key = {}
	num.primary_key.game = -1
	num.primary_key.boletus = 0
	num.primary_key.colony = 0
	num.primary_key.marge = 0

func init_dict():
	init_window_size()
	
	dict.token = {}
	dict.token.type = {
		"Wound": [],
		"Poison": [],
		"Flame": [],
		"Wave": [],
		"Lightning": [],
		"Fragility": [],
		"Energy Galore": [],
		"Spore Galore": [],
		"Replica": [],
#		"Shine": [],
#		"Doom": []
	}
	dict.token.subtype = {
		"Easy": [],
		"Normal": [],
		"Hard": []
	}
	dict.token.round = {
		"I": [],
		"III": [],
		"IV": []
	}
	
	dict.pollen = {}
	dict.pollen.label = {}
#	dict.pollen.variety = {
#		"Mediocre": []
#	}
	
	dict.tag = {}
	dict.tag.type = {}
	for type in dict.token.type.keys():
		dict.tag.type[type] = [type]
	dict.tag.energy = {
		"Slight": ["Easy","Normal"],
		"Serious": ["Normal","Hard"],
		"Standart": ["Easy","Normal","Hard"],
		"Easy": ["Easy"],
		"Normal": ["Normal"],
		"Hard": ["Hard"],
	}
	dict.tag.round = {
		"I": ["Poison","Flame","Lightning"],
		"III": ["Energy Galore","Spore Galore","Replica"],
		"IV": ["Wound","Wave","Fragility"]
	}
	dict.tag.role = {
		"Main": ["Poison","Flame","Lightning","Wound","Wave","Fragility"],
		"Support": ["Energy Galore","Spore Galore","Replica"]
	}
	
	dict.dna = {}
	
#	dict.dna.pack = {}
#
#	for key_f in dict.tag.role.keys():
#		dict.dna.pack[key_f] = {}
#
#		for key_s in dict.tag.role[key_f]:
#			dict.dna.pack[key_f][key_s] = []
	
	dict.dna.role = {
		"Main": [],
		"Hybrid" : [],
		"Support": []
	}
	
	for type in dict.token.type:
		var words = [type,type,type]
		
		for key in dict.tag.role.keys():
			if dict.tag.role[key].has(type):
				dict.dna.role[key].append(words)
		
	for _i in dict.tag.round.keys().size()-1:
		var key = dict.tag.round.keys()[_i]
		for type in dict.tag.round[key]:
			var words = [type]
			
			match key:
				"I":
					words.append(dict.tag.round["IV"][0]) 
					words.append(dict.tag.round["IV"][0]) 
					dict.dna.role["Hybrid"].append(words)
					words = [type,type]
					words.append(dict.tag.round["IV"][0]) 
					dict.dna.role["Hybrid"].append(words)
				"III":
					words.append(dict.tag.round["IV"][1]) 
					words.append(dict.tag.round["IV"][1]) 
					dict.dna.role["Hybrid"].append(words)
					words = [type,type]
					words.append(dict.tag.round["IV"][1]) 
					dict.dna.role["Hybrid"].append(words)
			
			words = [type]
			words.append(dict.tag.round["IV"][2]) 
			words.append(dict.tag.round["IV"][2]) 
			words = [type,type]
			words.append(dict.tag.round["IV"][2]) 
			dict.dna.role["Hybrid"].append(words)
			dict.dna.role["Hybrid"].append(words)
			
	dict.dna.types = []
	
	for role in dict.dna.role.keys():
		for types in dict.dna.role[role]:
			dict.dna.types.append(types)
			
	
	dict.round = {}
	dict.round.name = ["I","II","III","IV","V"]
	
	dict.counter = {}
	dict.counter.wood = ["Poison","Flame","Wave","Lightning","Fragility"]
	dict.counter.boletus = ["Energy Galore","Spore Galore","Replica"]
	
	dict.history = {}
	dict.history.colony = {}

func init_window_size():
	dict.window_size = {}
	dict.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	dict.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	dict.window_size.center = Vector2(dict.window_size.width/2, dict.window_size.height/2)

func init_arr():
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	
	arr.token = []
	arr.spore = []
	arr.colony = []
	arr.forest = []
	set_permutations()
	set_subtype()

func init_node():
	node.TimeBar = get_node("/root/Game/TimeBar") 
	node.Game = get_node("/root/Game") 

func init_flag():
	flag.click = false
	flag.game = false

func _ready():
	init_num()
	init_dict()
	init_arr()
	init_node()
	init_flag()

func get_wound_hp(start_, step_, charge_):
	var hp = start_
	var shift = step_
	var _i = 0
	
	while _i < charge_:
		_i += 1
		hp += shift
		shift += 1
		
	return hp

func save_json(data_,file_path_,file_name_):
	var file = File.new()
	file.open(file_path_+file_name_+".json", File.WRITE)
	file.store_line(to_json(data_))
	file.close()

func load_json(file_path_,file_name_):
	var file = File.new()
	
	if not file.file_exists(file_path_+file_name_+".json"):
			 #save_json()
			 return null
	
	file.open(file_path_+file_name_+".json", File.READ)
	var data = parse_json(file.get_as_text())
	return data

func get_analytics(index_):
	var data = {}
	var path = "res://json/chronicles/"+str(index_)+"/"
	var index = 0
	
	while index > -1:
		var name_ = str(index)
		var file_data = Global.load_json(path,name_)
		
		if file_data != null:
			data[index] = file_data
			index+=1
		else:
			index = -1

#	for colony in arr.colony:
#		data = colony.dict.chronicle
#		name_ = str(colony.num.index)
#		Global.save_json(data,path,name_)
#		var file_data = Global.load_json(path,name_)
	return data

func get_3_dna():
	var dnas = []
	var parent = {}
	parent.types = dict.dna.types
	parent.subtypes = arr.subtype
	
	for _i in num.size.dna:
		var input = {}
		
		for key in parent.keys():
			Global.rng.randomize()
			var index_r = Global.rng.randi_range(0, parent[key].size()-1)
			var words = parent[key][index_r]
			words.shuffle()
			
			input[key] = []
			input[key].append_array(words)
			#print(words)
		
		var dna = Classes.DNA.new(input)
		dnas.append(dna)
	
	#print(dnas)
	return dnas

func set_permutations():
	arr.permutation = []
	var max_ = pow(num.size.dna,num.size.dna)
	
	for _i in max_:
		var indexs = [0,0,0]
		var value = _i
		var _j = 0
		
		while value > 0:
			indexs[_j] += value%num.size.dna
			value /= num.size.dna
			_j += 1
		arr.permutation.append(indexs)

func set_subtype():
	arr.subtype = []
	
	for permutation in arr.permutation:
		var subtypes = []
		
		for index in permutation:
			subtypes.append(dict.token.subtype.keys()[index])
			
		arr.subtype.append(subtypes)
