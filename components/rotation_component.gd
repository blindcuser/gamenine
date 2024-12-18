class_name RotationComponent
extends Node

const SMOOTH_SPEED = 10.0

## The object that will be rotated
@export var character: CharacterBody3D

var direction:Vector3 = Vector3.FORWARD

func rotate90degRight() -> void:
	direction = direction.rotated(Vector3.MODEL_TOP, deg_to_rad(90))
	
func _physics_process(delta:float) -> void:
	character.rotation.y = lerp_angle(character.rotation.y, atan2(-direction.x, -direction.z), delta * SMOOTH_SPEED)
