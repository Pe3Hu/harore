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
	num.primary_key.token = 0
	num.primary_key.spore = 0
	num.primary_key.dna = 0
	num.primary_key.boletus = 0
	num.primary_key.colony = 0
	num.primary_key.wood = 0
	num.primary_key.marge = 0
	num.primary_key.forest = 0

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
	
	dict.spore = {}
	dict.spore
	dict.spore.variety = {
		"Mediocre": []
	}

func init_window_size():
	dict.window_size = {}
	dict.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	dict.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	dict.window_size.center = Vector2(dict.window_size.width/2, dict.window_size.height/2)

func init_arr():
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16] #, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	
	arr.token = []
	arr.spore = []
	arr.colony = []
	arr.forest = []
	arr.round = ["I","II","III","IV"]

func init_node():
	node.TimeBar = get_node("/root/Game/TimeBar") 
	node.Game = get_node("/root/Game") 

func init_flag():
	flag.click = false

func _ready():
	init_num()
	init_dict()
	init_arr()
	init_node()
	init_flag()
