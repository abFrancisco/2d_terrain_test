extends Node2D

var gridsize:int = 25
var rows:int = 10
var cols:int = 10
var grid:Array[PackedByteArray]

var tex:Texture2D = preload("res://icon.svg")

func _ready():
	pass

func _physics_process(delta):
	var dir = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	%Camera3D.rotate_y(delta*dir)

func generate_grid_random() -> void:
	randomize()
	grid.clear()
	for y in rows:
		var row: PackedByteArray = PackedByteArray()
		for x in cols:
			row.append(randi_range(0, 255))
			#print("("+str(x)+","+str(y)+") = "+str(row[x]))
		grid.append(row)
	#print(str(grid))

func calculate_grid_points() -> void:
	for y in rows:
		for x in cols:
			if x + 1 >= cols or y + 1 >= rows:
				continue
			
			pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		generate_grid_random()
		calculate_grid_points()
		call_deferred("queue_redraw")

func _draw():
	print("draw!!")
	if grid.is_empty():
		return
	for y in rows:
		for x in cols:
			var value:int = grid[x][y]
			var color:Color = Color8(255-value, value, 0)
			draw_circle(Vector2(x, y)*gridsize, max(abs(remap(value, 0, 255, -10, 10)), 3), color)
			#draw_polygon()
