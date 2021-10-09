extends Node2D

var listenPort: int = 11573
var listenHost: String = "127.0.0.1"
var udpServerComponent: UDPServer
var points = 68
var pointArr = []
export var factor = 1.5
var debugVBox

func _ready():
	udpServerComponent = UDPServer.new()
	udpServerComponent.listen(listenPort,listenHost)
	print_debug("opened UDP server: %s:%s" % [listenHost,listenPort])
	debugVBox = get_node("debug/debug_vbox")
	var template = $template
	for i in range(points):
		var x = template.duplicate()
		x.name = str(i) + "_point"
		add_child(x)
		pointArr.append(x)


func _process(_delta):
	udpServerComponent.poll()
	if udpServerComponent.is_connection_available():
		var conn = udpServerComponent.take_connection()
		#print_debug("package received from new host! (%s:%s)" % [conn.get_packet_ip(), conn.get_packet_port()])
		var data: PoolByteArray = conn.get_packet()
		#print_debug("received package - length: %s " % [data.size()])
		var dataPackage = {
			"time": -1,
			"id": -1,
			"cam": {
				"x": -1,
				"y": -1
			},
			"rightEyeOpen": -1,
			"leftEyeOpen": -1,
			"3d": -1,
			"fitError": -1,
			"quaternion": {
				"x": -1,
				"y": -1,
				"z": -1,
				"w": -1
			},
			"euler": {
				"x": -1,
				"y": -1,
				"z": -1
			},
			"translation": {
				"x": -1,
				"y": -1,
				"z": -1
			},
			"confidence": [],
			"points": [],
			"points3D": [],
			"features": {
				"EyeLeft": -1,
				"EyeRight": -1,
				"EyeBrowSteepnessLeft": -1,
				"EyeBrowUpDownLeft": -1,
				"EyeBrowQuirkLeft": -1,
				"EyeBrowSteepnessRight": -1,
				"EyeBrowUpDownRight": -1,
				"EyeBrowQuirkRight": -1,
				"MouthCornerUpDownLeft": -1,
				"MouthCornerInOutLeft": -1,
				"MouthCornerUpDownRight": -1,
				"MouthCornerInOutRight": -1,
				"MouthOpen": -1,
				"MouthWide": -1
			}
		}

		var streamBuff: StreamPeerBuffer = StreamPeerBuffer.new()
		var streamPos = 0
		streamBuff.data_array = data.subarray(streamPos,8)
		streamPos = streamPos + 8
		dataPackage["time"] = streamBuff.get_double()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["id"] = streamBuff.get_32()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["cam"]["x"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["cam"]["y"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["rightEyeOpen"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["leftEyeOpen"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+1)
		streamPos = streamPos + 1
		dataPackage["3d"] = streamBuff.get_8()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["fitError"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["quaternion"]["x"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["quaternion"]["y"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["quaternion"]["z"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["quaternion"]["w"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["euler"]["x"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["euler"]["y"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["euler"]["z"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["translation"]["x"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["translation"]["y"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["translation"]["z"] = streamBuff.get_float()

		#print("time: %d | id %d | cam x: %d y: %d | 3d?: %d | fitError: %d | quaternion: %d/%d/%d/%d | euler: %d/%d/%d | translation: %d/%d/%d" % [dataPackage["time"],dataPackage["id"],dataPackage["cam"]["x"],dataPackage["cam"]["y"],dataPackage["3d"],dataPackage["fitError"], dataPackage["quaternion"]["x"], dataPackage["quaternion"]["y"],dataPackage["quaternion"]["z"],dataPackage["quaternion"]["w"],dataPackage["euler"]["x"],dataPackage["euler"]["y"],dataPackage["euler"]["z"],dataPackage["translation"]["x"],dataPackage["translation"]["y"],dataPackage["translation"]["z"] ])

		for _i in range(points):
			streamBuff.data_array = data.subarray(streamPos,streamPos+4)
			streamPos = streamPos + 4
			dataPackage["confidence"].append(streamBuff.get_float())
		
		for _i in range(points):
			streamBuff.data_array = data.subarray(streamPos,streamPos+4)
			streamPos = streamPos + 4
			var a = streamBuff.get_float()
			streamBuff.data_array = data.subarray(streamPos,streamPos+4)
			streamPos = streamPos + 4
			var b = streamBuff.get_float()
			var v = Vector2(a,b)
			dataPackage["points"].append(v)
			pointArr[_i].position = v * factor

		for _i in range(points+2):
			streamBuff.data_array = data.subarray(streamPos,streamPos+4)
			streamPos = streamPos + 4
			var a = streamBuff.get_float()
			streamBuff.data_array = data.subarray(streamPos,streamPos+4)
			streamPos = streamPos + 4
			var b = streamBuff.get_float()
			streamBuff.data_array = data.subarray(streamPos,streamPos+4)
			streamPos = streamPos + 4
			var c = streamBuff.get_float()
			dataPackage["points3D"].append(Vector3(a,b,c))
			
		
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeLeft"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeRight"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeBrowSteepnessLeft"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeBrowUpDownLeft"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeBrowQuirkLeft"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeBrowSteepnessRight"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeBrowUpDownRight"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["EyeBrowQuirkRight"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["MouthCornerUpDownLeft"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["MouthCornerInOutLeft"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["MouthCornerUpDownRight"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["MouthCornerInOutRight"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["MouthOpen"] = streamBuff.get_float()
		streamBuff.data_array = data.subarray(streamPos,streamPos+4)
		streamPos = streamPos + 4
		dataPackage["features"]["MouthWide"] = streamBuff.get_float()

		for i in dataPackage["features"].keys():
			var n = debugVBox.get_node_or_null("obj_"+i)
			if n == null:
				n = Label.new()
				n.name = "obj_"+i
				debugVBox.add_child(n)
			n.text = i + ": " + str(dataPackage["features"][i])
