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

func init_primary_key():
	num.primary_key = {}
	num.primary_key.game = -1
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
		"Shine": [],
		"Doom": []
	}
	#["Slight","Standart","Serious"]
	dict.token.subtype = {
		"Easy": [],
		"Normal": [],
		"Hard": []
	}
	
	dict.tag = {}
	dict.tag.pollen = ["Wound","Poison","Flame"]
	
	dict.pollen = {}
	dict.pollen.tag = {}
	dict.pollen.variety = {
		"Mediocre": []
	}
	dict.dna = {}
	dict.dna.tag = {}
	
	dict.round = {}
	dict.round.name = ["I","II","III","IV","V"]
	
	dict.counter = {}
	dict.counter.type = ["Poison","Flame","Wave","Lightning"]
	
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

func get_analytics():
	var data = {}
	var path = "res://json/chronicles/"+str(Global.num.primary_key.game)+"/"
	var index = 0
	
	while index > -1:
		var name_ = str(index)
		var file_data = Global.load_json(path,name_)
		data[index] = {}
		data[index].round = -1
		data[index].energy = 0
		
		if file_data != null:
			var keys = file_data.keys()
			for boletus in keys:
				for data_ in file_data[boletus]:
					data[index].energy += data_.energy
					data[index].round = max(data[index].round,data_.round)
			
			print(index,data[index])
			index+=1
		else:
			index = -1

#	for colony in arr.colony:
#		data = colony.dict.chronicle
#		name_ = str(colony.num.index)
#		Global.save_json(data,path,name_)
#		var file_data = Global.load_json(path,name_)
