extends Node2D

func _ready():
	%CollisionPolygon.polygon = $Visual.polygon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clip_things():
	var cut_result:Array[PackedVector2Array] = Geometry2D.clip_polygons($Visual.polygon, $CutShape.polygon)
	var ss2d_done:bool = false
	$Visual.queue_free()
	$Collision.queue_free()
	$CutShape2.queue_free()
	$CutShape.queue_free()
	for polygon in cut_result:
		var visual_shape = Polygon2D.new()
		visual_shape.polygon = polygon
		#add_child(visual_shape)
		
		var collision_body = StaticBody2D.new()
		var collision_shape = CollisionPolygon2D.new()
		collision_shape.polygon = polygon
		collision_body.add_child(collision_shape)
		add_child(collision_body)
		
		generate_ss2d(polygon)
	print("im clipping things")

func generate_ss2d(polygon:PackedVector2Array) -> void:
	#setup
	var _ss2d_shape:SS2D_Shape_Closed = SS2D_Shape_Closed.new()
	var _ss2d_points:SS2D_Point_Array = SS2D_Point_Array.new()
	_ss2d_shape.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	_ss2d_shape._points = _ss2d_points
	#this material was created on a smartshape2d in the editor and then saved
	_ss2d_shape.shape_material = load("res://test_ss2d_material.tres")
	for point in polygon:
		_ss2d_points.add_point(point)
	
	#add first point to the end of the point array to close the polygon
	_ss2d_points.add_point(_ss2d_points.get_point_at_index(0).position)
	get_tree().get_root().add_child(_ss2d_shape)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		clip_things()
