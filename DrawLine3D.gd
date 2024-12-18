extends Node2D

class Line:
	var Start:Vector3
	var End:Vector3
	var LineColor:Color
	var time:float
	
	func _init(_Start:Vector3, _End:Vector3, _LineColor:Color, _time:float) -> void:
		self.Start = _Start
		self.End = _End
		self.LineColor = _LineColor
		self.time = _time

var Lines:Array[Line] = []
var RemovedLine:bool = false

func _process(delta:float) -> void:
	for i in range(len(Lines)):
		Lines[i].time -= delta
	
	if(len(Lines) > 0 || RemovedLine):
		queue_redraw() #Calls _draw
		RemovedLine = false

func _draw() -> void:
	var Cam:Camera3D = get_viewport().get_camera_3d()
	for i in range(len(Lines)):
		var ScreenPointStart:Vector2 = Cam.unproject_position(Lines[i].Start)
		var ScreenPointEnd:Vector2 = Cam.unproject_position(Lines[i].End)
		
		#Dont draw line if either start or end is considered behind the camera
		#this causes the line to not be drawn sometimes but avoids a bug where the
		#line is drawn incorrectly
		if(Cam.is_position_behind(Lines[i].Start) ||
			Cam.is_position_behind(Lines[i].End)):
			continue
		
		draw_line(ScreenPointStart, ScreenPointEnd, Lines[i].LineColor)
	
	#Remove lines that have timed out
	var i:int = Lines.size() - 1
	while (i >= 0):
		if(Lines[i].time < 0.0):
			Lines.remove_at(i)
			RemovedLine = true
		i -= 1

func DrawLine(Start:Vector3, End:Vector3, LineColor:Color, time:float = 0) -> void:
	Lines.append(Line.new(Start, End, LineColor, time))

func DrawRay(Start:Vector3, Ray:Vector3, LineColor:Color, time:float = 0) -> void:
	Lines.append(Line.new(Start, Start + Ray, LineColor, time))

func DrawCube(Center:Vector3, HalfExtents:float, LineColor:Color, time:float = 0) -> void:
	#Start at the 'top left'
	var LinePointStart:Vector3 = Center
	LinePointStart.x -= HalfExtents
	LinePointStart.y += HalfExtents
	LinePointStart.z -= HalfExtents
	
	#Draw top square
	var LinePointEnd:Vector3 = LinePointStart + Vector3(0, 0, HalfExtents * 2)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	
	#Draw bottom square
	LinePointStart = LinePointEnd + Vector3(0, -HalfExtents * 2.0, 0)
	LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, time);
	
	#Draw vertical lines
	LinePointStart = LinePointEnd
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)
	LinePointStart += Vector3(0, 0, HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)
	LinePointStart += Vector3(HalfExtents * 2.0, 0, 0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)
	LinePointStart += Vector3(0, 0, -HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, time)
