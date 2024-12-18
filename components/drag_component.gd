class_name DragComponent
extends Node

signal touched

static var SNAP_TO:Vector3 = Vector3(2,1,2)

static var DRAGGING:bool = false

@export var DRAGGING_SPEED: int = 50

## The object that will be moved by the drag-component
@export var character: CharacterBody3D

## The collision-shape that will be enabled during dragging to prevent to get
## stuck
@export var draggingCollisionShape: CollisionShape3D

## The touching-shape that will be disabled during dragging to prevent to get 
## stuck, but is bigger for better teuching
@export var touchingCollisionShape: CollisionShape3D


@export_flags_3d_physics var collision_mask:int


var characterTargetPosition:Vector3
var doDrag:bool = false
var draged:bool = false
var params:PhysicsRayQueryParameters3D
var dragOffset:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(character != null, "DragComponent -> Character not set!")
	set_new_position(character.global_position)

func _unhandled_input(event:InputEvent) -> void:
	
	if(doDrag && event is InputEventMouse && event is not InputEventMouseButton) :
		var intersect:Dictionary = \
			get_mouse_intersect(event.position, true, true)
		draged = true
		set_new_position(intersect.position + dragOffset)
	if event is InputEventMouseButton:
		var leftButtonPressed:bool \
			= event.button_index == MOUSE_BUTTON_LEFT && event.pressed
		var leftButtonReleased:bool \
			= event.button_index == MOUSE_BUTTON_LEFT && !event.pressed
		if (leftButtonReleased && doDrag):
			_stop_dragging()
		elif (leftButtonPressed && !DRAGGING):
			_start_dragging(event.position)

func _start_dragging(position:Vector2) -> void:
	var intersect:Dictionary = get_mouse_intersect(position, false, false)
	if(intersect.collider == character):
		dragOffset = character.global_position \
			- get_mouse_intersect(position, true, true).position
		DRAGGING = true
		if draggingCollisionShape: draggingCollisionShape.disabled = false
		if touchingCollisionShape: touchingCollisionShape.disabled = true
		doDrag = true
		
func _stop_dragging() -> void:
	DRAGGING = false
	doDrag = false
	set_new_position(character.global_position)
	if draggingCollisionShape: draggingCollisionShape.disabled = true
	if touchingCollisionShape: touchingCollisionShape.disabled = false
	if !draged:
		touched.emit()
	draged = false

func set_new_position(intersectPosition: Vector3) -> void:
	characterTargetPosition = snapped(intersectPosition, SNAP_TO)
			
func get_mouse_intersect(\
		currentMousePosition:Vector2,\
		excludeSelf:bool,\
		onlyFloor:bool) -> Dictionary:
	var currentCamera:Camera3D = get_viewport().get_camera_3d()
	var currentParams:PhysicsRayQueryParameters3D =\
			 PhysicsRayQueryParameters3D.new()
	currentParams.from = \
		currentCamera.project_ray_origin(currentMousePosition)
	currentParams.to = \
		currentCamera.project_position(currentMousePosition, 1000)
	if(onlyFloor):
		currentParams.collide_with_areas = true
		currentParams.collide_with_bodies = false
		currentParams.collision_mask = collision_mask
	if excludeSelf: 
		currentParams.exclude = [character]
	var worldspace:PhysicsDirectSpaceState3D = \
		character.get_world_3d().direct_space_state
	var result:Dictionary = worldspace.intersect_ray(currentParams)
	return result
	
func _process(_delta:float) -> void:
	if (characterTargetPosition.distance_to(character.global_position) > 0.01 ):
		character.velocity = \
			(characterTargetPosition - character.global_position)*DRAGGING_SPEED
		character.move_and_slide()
