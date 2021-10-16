extends Node

var pointTemplate

var pointArr = []
var cl: CanvasLayer
var baseX: float
var baseY: float
var noDebug: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	cl = CanvasLayer.new()
	cl.layer = 10
	add_child(cl)
	pointTemplate = load("res://pointTemplate.tscn")
	for i in range($OSF.points):
		var x: Polygon2D = pointTemplate.instance()
		x.name = str(i) + "_point"
		cl.add_child(x)
		pointArr.append(x)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Button_pressed():
	$OSF.startServer()

func _on_LineEdit_text_changed(new_text):
	$puppetMaster.scaleFactor = float(new_text)

func _on_LineEdit2_text_changed(new_text):
	$puppetMaster.eyeHeight = float(new_text)


func _on_LineEdit3_text_changed(new_text):
	$puppetMaster.moveBaseTransformX = float(new_text)
	baseX = float(new_text)


func _on_LineEdit4_text_changed(new_text):
	$puppetMaster.moveBaseTransformY = float(new_text)
	baseY = float(new_text)


func _on_OSF_onDataPackage(_package):
	$VBoxContainer/eyePos.text = str($puppetMaster/CanvasLayer/eyeL.rect_global_position)
	var scale = $puppetMaster.scaleFactor
	for _i in range(_package.points.size()):
		var v = Vector2(_package.points[_i].x*scale - baseX, _package.points[_i].y*scale - baseY)
		pointArr[_i].position = v

func _on_CheckBox_pressed():
	for i in range($OSF.points):
		pointArr[i].visible = $VBoxContainer/CheckBox.pressed
