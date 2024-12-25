class_name GlobalRotateCameraComponent
extends Node

var _angular_acceleration:float = 10
var _target_rotation_y_steps:int = 0
var _node3d:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_node3d = self.get_parent()
	GlobalSignal.action_view_rotate_camera_left.connect(rotate_left)
	GlobalSignal.action_view_rotate_camera_right.connect(rotate_right)

func rotate_left() -> void:
	_target_rotation_y_steps += 1

func rotate_right() -> void:
	_target_rotation_y_steps -= 1
	
func _physics_process(delta: float) -> void:
	_node3d.rotation.y = lerp(_node3d.rotation.y, deg_to_rad(_target_rotation_y_steps*90), delta * _angular_acceleration )
