extends Node3D

@onready var spawner_component: SpawnerComponent = $SpawnerComponent as SpawnerComponent


func _on_drag_component_touched() -> void:
	spawner_component.spawn()
