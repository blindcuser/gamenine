# Give the component a class name so it can be instanced as a custom node
class_name SpawnerComponent
extends Node3D

# Export the dependencies for this component
# The scene we want to spawn
@export var scene: PackedScene

# Spawn an instance of the scene at a specific global position on a parent
# By default the parent is the current "main" scene , but you can pass in
# an alternative parent if you so choose.
func spawn(global_spawn_position: Vector3 = global_position, parent: Node = get_tree().current_scene) -> Node:
	assert(scene is PackedScene, "Error: The scene export was never set on this spawner component.")
	# Instance the scene
	var instance: Node3D = scene.instantiate()
	# Add it as a child of the parent
	parent.add_child(instance)
	# Update the global position of the instance.
	# (This must be done after adding it as a child)
	instance.global_position = global_spawn_position
	if(instance.has_method("set_direction") && instance.has_method("get_direction")):
		var current_direction:Vector3 = instance.get_direction()
		var new_rotation:float = self.global_rotation.y
		var new_direction:Vector3 = current_direction.rotated(Vector3.UP, new_rotation)
		instance.set_direction(new_direction)
		
	# Return the instance in case we want to perform any other operations
	# on it after instancing it.
	return instance
