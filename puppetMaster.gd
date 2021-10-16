extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var puppetEyeL: TextureRect
var puppetEyeR: TextureRect
var puppetEyebrowL: TextureRect
var puppetEyebrowR: TextureRect
var puppetNose: TextureRect
var puppetMouth: TextureRect
var puppetFace: TextureRect
var puppetFacePolygon: Polygon2D

export var eyeHeight: float = 60
export var scaleFactor: float = 1.5
export var moveBaseTransformX: float = -50
export var moveBaseTransformY: float = -50


# Called when the node enters the scene tree for the first time.
func _ready():
	puppetEyeL = $CanvasLayer/eyeL
	puppetEyeR = $CanvasLayer/eyeR
	puppetEyebrowL = $CanvasLayer/eyebrowL
	puppetEyebrowR = $CanvasLayer/eyebrowR
	puppetNose = $CanvasLayer/nose
	puppetMouth = $CanvasLayer/mouth
	var tmpPuppetFace = $CanvasLayer/face
	if tmpPuppetFace is Polygon2D:
		puppetFacePolygon = tmpPuppetFace
	else:
		puppetFace = tmpPuppetFace
	pass # Replace with function body.


func _on_OSF_onDataPackage(package):
	var eyebrowLpos = package.points[17]
	var eyebrowLposEnd = package.points[21]
	var eyebrowRpos = package.points[22]
	var eyebrowRposEnd = package.points[26]
	var eyeLpos = package.points[36]
	var eyeLposEnd = package.points[39]
	var eyeRpos = package.points[42]
	var eyeRposEnd = package.points[45]
	var noseTop = package.points[27]
	var noseLeft = package.points[31]
	var noseRight = package.points[35]
	var mouthLeft = package.points[58]
	var mouthRight = package.points[62]
	var mouthTop = package.points[60]
	var mouthBottom = package.points[64]
	var faceLeft = package.points[0]
	var faceRight = package.points[16]
	var faceBottom = package.points[8]
	

	#0-16

	puppetEyeL.set_global_position(Vector2(eyeLpos.x*scaleFactor - moveBaseTransformX,eyeLpos.y*scaleFactor  - moveBaseTransformY))
	puppetEyeL.rect_size = Vector2(eyeLposEnd.x*scaleFactor - eyeLpos.x*scaleFactor, eyeHeight)
	puppetEyeL.rect_global_position.y = puppetEyeL.rect_global_position.y - puppetEyeL.texture.get_size().y / 2
	puppetEyeR.set_global_position(Vector2(eyeRpos.x*scaleFactor - moveBaseTransformX,eyeRpos.y*scaleFactor  - moveBaseTransformY))
	puppetEyeR.rect_size = Vector2(eyeRposEnd.x*scaleFactor - eyeRpos.x*scaleFactor, eyeHeight)
	puppetEyeR.rect_global_position.y = puppetEyeR.rect_global_position.y - puppetEyeR.texture.get_size().y / 2

	puppetEyebrowL.set_global_position(Vector2(eyebrowLpos.x*scaleFactor - moveBaseTransformX,eyebrowLposEnd.y*scaleFactor  - moveBaseTransformY))
	puppetEyebrowL.rect_size = Vector2(eyebrowLposEnd.x*scaleFactor - eyebrowLpos.x*scaleFactor, eyeHeight)
	puppetEyebrowL.rect_global_position.y = puppetEyebrowL.rect_global_position.y - puppetEyebrowL.texture.get_size().y / 2

	puppetEyebrowR.set_global_position(Vector2(eyebrowRpos.x*scaleFactor - moveBaseTransformX,eyebrowRpos.y*scaleFactor  - moveBaseTransformY))
	puppetEyebrowR.rect_size = Vector2(eyebrowRposEnd.x*scaleFactor - eyebrowRpos.x*scaleFactor, eyeHeight)
	puppetEyebrowR.rect_global_position.y = puppetEyebrowR.rect_global_position.y - puppetEyebrowR.texture.get_size().y / 2

	# top left = nose bottom left.x / nose top.y
	puppetNose.set_global_position(Vector2(noseLeft.x*scaleFactor - moveBaseTransformX,noseTop.y*scaleFactor  - moveBaseTransformY))
	puppetNose.rect_size = Vector2((noseRight.x - noseLeft.x)*scaleFactor, (noseRight.y*scaleFactor) - (noseTop.y*scaleFactor))

	
	puppetMouth.set_global_position(Vector2(mouthLeft.x*scaleFactor - moveBaseTransformX,mouthTop.y*scaleFactor  - moveBaseTransformY))
	puppetMouth.rect_size = Vector2((mouthRight.x - mouthLeft.x)*scaleFactor, (mouthBottom.y*scaleFactor) - (mouthTop.y*scaleFactor) + eyeHeight)
	puppetMouth.rect_global_position.y = puppetMouth.rect_global_position.y - puppetMouth.texture.get_size().y / 2
	
	#puppetFace.set_global_position(Vector2(faceLeft.x*scaleFactor - moveBaseTransformX,faceLeft.y*scaleFactor - (faceBottom.y*scaleFactor - faceRight.y*scaleFactor) - moveBaseTransformY))
	#puppetFace.rect_size = Vector2((faceRight.x - faceLeft.x)*scaleFactor, (faceBottom.y*scaleFactor - faceRight.y*scaleFactor)*2)

	if puppetFace != null:
		puppetFace.set_global_position(Vector2(faceLeft.x*scaleFactor - moveBaseTransformX,faceLeft.y*scaleFactor - moveBaseTransformY))
		puppetFace.rect_size = Vector2((faceRight.x - faceLeft.x)*scaleFactor, (faceBottom.y*scaleFactor - faceRight.y*scaleFactor))
	else:
		var a := PoolVector2Array()

		for i in range(17):
			a.append(Vector2(package.points[i].x - package.points[0].x, package.points[i].y - package.points[0].y))
		puppetFacePolygon.polygon = a
		puppetFacePolygon.global_position = Vector2(package.points[0].x, package.points[0].y)

		#puppetFacePolygon.uv = a
		#puppetFace.rect_global_position.y = puppetFace.rect_global_position.y - puppetFace.texture.get_size().y / 2
